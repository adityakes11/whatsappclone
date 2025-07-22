import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCWWLc0qTcj8r9bZL9AUSvAv79Acxpl3dc',
    appId: '1:564484916645:web:c7c8aa5f1c1c474ec9544c',
    messagingSenderId: '564484916645',
    projectId: 'whatsapp--back-eee30',
    authDomain: 'whatsapp--back-eee30.firebaseapp.com',
    storageBucket: 'whatsapp--back-eee30.firebasestorage.app',
    measurementId: 'G-JYYWDS51BX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAwyx-xTr1wp2_vA3XC6I6tX9zRW5RJVW8',
    appId: '1:564484916645:android:a0af2dfd7d48ae32c9544c',
    messagingSenderId: '564484916645',
    projectId: 'whatsapp--back-eee30',
    storageBucket: 'whatsapp--back-eee30.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCyhpQEIbTNOB5jaA81iiH_vIRLHde17fY',
    appId: '1:564484916645:ios:f00937544be50ce9c9544c',
    messagingSenderId: '564484916645',
    projectId: 'whatsapp--back-eee30',
    storageBucket: 'whatsapp--back-eee30.firebasestorage.app',
    iosBundleId: 'com.example.whatsappUi',
  );
}
