import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';
import 'package:whatsapp_ui/models/user_model.dart';

class ChatRepository{
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRepository({required this.firestore, required this.auth});

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String recieverUserId,
    required UserModel senderUser,
})async{
    try{
      //users -> sender id-> receiver id -> messages -> message id ->
      var timeSent = DateTime.now();
      UserModel recieverUserData;

      var userDataMap = await firestore.collection('users').doc(recieverUserId).get();
      
      recieverUserData = UserModel.fromMap(userDataMap.data()!);

      //users -> reciever user id -> chats ->current user id -> set data ,
    }catch (e){
      showSnackBar(context: context, content: e.toString());
    }
  }

}