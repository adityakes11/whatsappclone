import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp_ui/common/widgets/loader.dart';
import 'package:whatsapp_ui/config/agora_config.dart';
import 'package:whatsapp_ui/features/call/controller/call_controller.dart';
import 'package:whatsapp_ui/models/call.dart';

class CallScreen extends ConsumerStatefulWidget {
  final String channelId;
  final Call call;
  final bool isGroupChat;
  const CallScreen({
    Key? key,
    required this.channelId,
    required this.call,
    required this.isGroupChat,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CallScreenState();
}

class _CallScreenState extends ConsumerState<CallScreen> {
  late RtcEngine _engine;
  int? _remoteUid;
  bool _localUserJoined = false;

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    // Request camera and microphone permissions
    await [Permission.microphone, Permission.camera].request();

    // Create the engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(
      appId: AgoraConfig.appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    // Set up event handlers
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
          });
          // End the call for the receiver when the caller hangs up
          Navigator.pop(context);
        },
      ),
    );

    await _engine.enableVideo();
    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    // Note: For production, you need to fetch a token from your server
    // and pass it to joinChannel. Using the App ID without a token
    // is only for testing purposes.
    await _engine.joinChannel(
      token: AgoraConfig.token, // Use your token if you have one
      channelId: widget.channelId,
      uid: 0, // 0 means Agora assigns a UID automatically
      options: const ChannelMediaOptions(),
    );
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  // --- UI Building ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _localUserJoined == false
          ? const Loader()
          : SafeArea(
        child: Stack(
          children: [
            // Remote user's video
            Center(child: _remoteVideo()),
            // Local user's video
            Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 120,
                height: 160,
                child: _localPreview(),
              ),
            ),
            // Call control buttons
            _toolbar(),
          ],
        ),
      ),
    );
  }

  Widget _localPreview() {
    if (_localUserJoined) {
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: _engine,
          canvas: const VideoCanvas(uid: 0),
        ),
      );
    } else {
      return const Center(
        child: Text(
          'Joining Channel...',
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: widget.channelId),
        ),
      );
    } else {
      return const Text(
        'Waiting for the other user to join...',
        textAlign: TextAlign.center,
      );
    }
  }

  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // End call button
          RawMaterialButton(
            onPressed: () {
              ref.read(callControllerProvider).endCall(
                widget.call.callerId,
                widget.call.receiverId,
                context,
              );
              // The onUserOffline callback will handle popping the screen
              // for the other user. We pop it manually for the current user.
              Navigator.pop(context);
            },
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
            child: const Icon(Icons.call_end, color: Colors.white, size: 35.0),
          ),
        ],
      ),
    );
  }
}