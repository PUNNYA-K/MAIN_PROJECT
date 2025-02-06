// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyCOEu0F77nJNvoz08b5pRZzdhHFolYCZBE',
    appId: '1:893481173875:web:01a5eb39ac3cb30cebfb06',
    messagingSenderId: '893481173875',
    projectId: 'main-project-53f7b',
    authDomain: 'main-project-53f7b.firebaseapp.com',
    storageBucket: 'main-project-53f7b.firebasestorage.app',
    measurementId: 'G-ZC854XF77L',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCc-0wteCpI-Km1g_0o6YT-Jd0Zpr9VDZ4',
    appId: '1:893481173875:android:f3fb5f01423b8e94ebfb06',
    messagingSenderId: '893481173875',
    projectId: 'main-project-53f7b',
    storageBucket: 'main-project-53f7b.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA6q2hfktV3x5jhBMeHs_hrm6Q20mQuBc8',
    appId: '1:893481173875:ios:dd92b63a7f60ea88ebfb06',
    messagingSenderId: '893481173875',
    projectId: 'main-project-53f7b',
    storageBucket: 'main-project-53f7b.firebasestorage.app',
    iosBundleId: 'com.example.mainProject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA6q2hfktV3x5jhBMeHs_hrm6Q20mQuBc8',
    appId: '1:893481173875:ios:dd92b63a7f60ea88ebfb06',
    messagingSenderId: '893481173875',
    projectId: 'main-project-53f7b',
    storageBucket: 'main-project-53f7b.firebasestorage.app',
    iosBundleId: 'com.example.mainProject',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCOEu0F77nJNvoz08b5pRZzdhHFolYCZBE',
    appId: '1:893481173875:web:52daf155d0c22dd4ebfb06',
    messagingSenderId: '893481173875',
    projectId: 'main-project-53f7b',
    authDomain: 'main-project-53f7b.firebaseapp.com',
    storageBucket: 'main-project-53f7b.firebasestorage.app',
    measurementId: 'G-GDD8JEQ69T',
  );
}
