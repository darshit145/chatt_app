import 'package:firebase_messaging/firebase_messaging.dart';

import '../screen/auth/api.dart';
String deviceTocken="NO";
class FirebaseChatAppMessaginc{
  static FirebaseMessaging firebaseMessaging=FirebaseMessaging.instance;
  static Future<String?> forGettingFirebaseMessagingTockon() async {
    await firebaseMessaging.requestPermission();
    firebaseMessaging.getToken().then((tockon){
      if(tockon!=null){
        print("Tockon: $tockon");
        deviceTocken=tockon;
      }
    });
  }
}