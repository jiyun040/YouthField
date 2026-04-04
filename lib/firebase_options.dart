import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyC-i3DAy4Vc0cTdQZSIwse6jOOngDn2758',
    appId: '1:1017186877485:web:26a58b8848ea85c39cb8a4',
    messagingSenderId: '1017186877485',
    projectId: 'youthfield-a4fd8',
    authDomain: 'youthfield-a4fd8.firebaseapp.com',
    storageBucket: 'youthfield-a4fd8.firebasestorage.app',
    measurementId: 'G-TP67RK37BP',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBY5QnzpFTGUOCNVHILjcLuTqZJbX-Knl8',
    appId: '1:1017186877485:android:7ed954100cea5db59cb8a4',
    messagingSenderId: '1017186877485',
    projectId: 'youthfield-a4fd8',
    storageBucket: 'youthfield-a4fd8.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBCwu58d4jOZ2xVlDkBrQ5jjeia7gejvlg',
    appId: '1:1017186877485:ios:72f9757cdef4ee8b9cb8a4',
    messagingSenderId: '1017186877485',
    projectId: 'youthfield-a4fd8',
    storageBucket: 'youthfield-a4fd8.firebasestorage.app',
    iosClientId: '1017186877485-191mmr205hqb3n6rjncjeed460kpi9lg.apps.googleusercontent.com',
    iosBundleId: 'com.example.youthfield',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBCwu58d4jOZ2xVlDkBrQ5jjeia7gejvlg',
    appId: '1:1017186877485:ios:72f9757cdef4ee8b9cb8a4',
    messagingSenderId: '1017186877485',
    projectId: 'youthfield-a4fd8',
    storageBucket: 'youthfield-a4fd8.firebasestorage.app',
    iosClientId: '1017186877485-191mmr205hqb3n6rjncjeed460kpi9lg.apps.googleusercontent.com',
    iosBundleId: 'com.example.youthfield',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC-i3DAy4Vc0cTdQZSIwse6jOOngDn2758',
    appId: '1:1017186877485:web:2a5fad6dc82bcbb09cb8a4',
    messagingSenderId: '1017186877485',
    projectId: 'youthfield-a4fd8',
    authDomain: 'youthfield-a4fd8.firebaseapp.com',
    storageBucket: 'youthfield-a4fd8.firebasestorage.app',
    measurementId: 'G-RTTE6N74XK',
  );
}
