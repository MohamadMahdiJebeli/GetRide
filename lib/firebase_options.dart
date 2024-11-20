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
    apiKey: 'AIzaSyBtJNyjGLevE__N3Sl3h8KKdeYUpbpfEMo',
    appId: '1:974932774075:web:4e1e4e3af3eee1693b2d9e',
    messagingSenderId: '974932774075',
    projectId: 'getride-firebase',
    authDomain: 'getride-firebase.firebaseapp.com',
    storageBucket: 'getride-firebase.firebasestorage.app',
    measurementId: 'G-LRJRLQZCXG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCdrlr97wX_oznd9xKfI1WnVYDi6z3JkXc',
    appId: '1:974932774075:android:aca6eabedae0528d3b2d9e',
    messagingSenderId: '974932774075',
    projectId: 'getride-firebase',
    storageBucket: 'getride-firebase.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBo8ffVQqymCchSW47m1mIna2Yq5MARS_k',
    appId: '1:974932774075:ios:008e5532c1f746cc3b2d9e',
    messagingSenderId: '974932774075',
    projectId: 'getride-firebase',
    storageBucket: 'getride-firebase.firebasestorage.app',
    iosBundleId: 'com.example.getride',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBo8ffVQqymCchSW47m1mIna2Yq5MARS_k',
    appId: '1:974932774075:ios:008e5532c1f746cc3b2d9e',
    messagingSenderId: '974932774075',
    projectId: 'getride-firebase',
    storageBucket: 'getride-firebase.firebasestorage.app',
    iosBundleId: 'com.example.getride',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBtJNyjGLevE__N3Sl3h8KKdeYUpbpfEMo',
    appId: '1:974932774075:web:a150f44f5bd0eac53b2d9e',
    messagingSenderId: '974932774075',
    projectId: 'getride-firebase',
    authDomain: 'getride-firebase.firebaseapp.com',
    storageBucket: 'getride-firebase.firebasestorage.app',
    measurementId: 'G-VHSBH02DMP',
  );

}