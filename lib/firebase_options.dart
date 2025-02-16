// // File generated by FlutterFire CLI.
// // ignore_for_file: type=lint
// import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
// import 'package:flutter/foundation.dart'
//     show defaultTargetPlatform, kIsWeb, TargetPlatform;

// /// Default [FirebaseOptions] for use with your Firebase apps.
// ///
// /// Example:
// /// ```dart
// /// import 'firebase_options.dart';
// /// // ...
// /// await Firebase.initializeApp(
// ///   options: DefaultFirebaseOptions.currentPlatform,
// /// );
// /// ```
// class DefaultFirebaseOptions {
//   static FirebaseOptions get currentPlatform {
//     if (kIsWeb) {
//       throw UnsupportedError(
//         'DefaultFirebaseOptions have not been configured for web - '
//         'you can reconfigure this by running the FlutterFire CLI again.',
//       );
//     }
//     switch (defaultTargetPlatform) {
//       case TargetPlatform.android:
//         return android;
//       case TargetPlatform.iOS:
//         throw UnsupportedError(
//           'DefaultFirebaseOptions have not been configured for ios - '
//           'you can reconfigure this by running the FlutterFire CLI again.',
//         );
//       case TargetPlatform.macOS:
//         throw UnsupportedError(
//           'DefaultFirebaseOptions have not been configured for macos - '
//           'you can reconfigure this by running the FlutterFire CLI again.',
//         );
//       case TargetPlatform.windows:
//         return windows;
//       case TargetPlatform.linux:
//         throw UnsupportedError(
//           'DefaultFirebaseOptions have not been configured for linux - '
//           'you can reconfigure this by running the FlutterFire CLI again.',
//         );
//       default:
//         throw UnsupportedError(
//           'DefaultFirebaseOptions are not supported for this platform.',
//         );
//     }
//   }

//   static const FirebaseOptions android = FirebaseOptions(
//     apiKey: 'AIzaSyC3anyzGh3caaboT2XqqH_LIW5zfZpIuMA',
//     appId: '1:366733455085:android:9654988103e80c63a3a6e4',
//     messagingSenderId: '366733455085',
//     projectId: 'dthlmspro',
//     storageBucket: 'dthlmspro.appspot.com',
//   );

//   static const FirebaseOptions windows = FirebaseOptions(
//     apiKey: 'AIzaSyBQObXw6tBAqZelbneMYQNNsU3AVd3R5jI',
//     appId: '1:366733455085:web:aa52ba8900b0ffe5a3a6e4',
//     messagingSenderId: '366733455085',
//     projectId: 'dthlmspro',
//     authDomain: 'dthlmspro.firebaseapp.com',
//     storageBucket: 'dthlmspro.appspot.com',
//     measurementId: 'G-FBGT9XQLCY',
//   );
// }
