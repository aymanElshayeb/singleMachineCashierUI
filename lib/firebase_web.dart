import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseWeb {
  static void webInitializeFirebase(
      Map dataProjectConfig, Map authProjectConfig) async {
    await Firebase.initializeApp(
      name: 'data',
      options: FirebaseOptions(
          apiKey: dataProjectConfig['apiKey'],
          authDomain: dataProjectConfig['authDomain'],
          projectId: dataProjectConfig['projectId'],
          storageBucket: dataProjectConfig['storageBucket'],
          messagingSenderId: dataProjectConfig['messagingSenderId'],
          appId: dataProjectConfig['appId']),
    );
    await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: authProjectConfig['apiKey'],
          authDomain: authProjectConfig['authDomain'],
          projectId: authProjectConfig['projectId'],
          storageBucket: authProjectConfig['storageBucket'],
          messagingSenderId: authProjectConfig['messagingSenderId'],
          appId: authProjectConfig['appId']),
    );
  }

  static get dataFirebaseInstance =>
      kIsWeb ? FirebaseFirestore.instanceFor(app: Firebase.app('data')) : null;
  static get authFirebaseInstance => kIsWeb ? FirebaseFirestore.instance : null;
}
