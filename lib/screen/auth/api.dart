import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:chat_app/screen/auth/chat_modal.dart';
import 'package:chat_app/screen/auth/chat_users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../messaging/firebase_chat_app_messaginc.dart';
class Api {
  static late ChatUsers me;
  static FirebaseStorage firebaseStorage=FirebaseStorage.instance;
  static FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  static Future<bool> userExist() async {
    return (await firebaseFirestore
            .collection('chats')
            .doc(auth.currentUser!.uid)
            .get())
        .exists;
  }
  static getCurrentInfo()async{
    firebaseFirestore.collection('chats').doc(auth.currentUser!.uid).get().then((val)async{
      if(val.exists){
        String jesonEncoded=jsonEncode(val.data());


        me=await ChatUsers.fromJson2(jsonDecode(jesonEncoded));

      }else{
        await createUser().then((v){
          getCurrentInfo();
        });
      }
    });

  }

  static User get userData => auth.currentUser!;

  static Future createUser() async {
    final user = ChatUsers(
        id: userData.uid.toString(),
        name: userData.displayName.toString(),
        image: userData.photoURL.toString(),
        about: "Hi Ok",
        createdAt: "time",
        email: userData.email.toString(),
        isOnline:  true,
        lase_active: "time",
        push_tocken: "");

    return await firebaseFirestore
        .collection('chats')
        .doc(userData.uid)
        .set(user.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getallUser() {
    print("object");
    return firebaseFirestore
        .collection("chats")
        .where("id", isNotEqualTo: userData.uid)
        .snapshots();
  }

  static  forUpdatingtheUserInfo() async {
    await firebaseFirestore
        .collection('chats')
        .doc(auth.currentUser!.uid).update(me.toJson());
        
  }

  static String conversationId(String id)=>userData.uid.hashCode<=id.hashCode?"${userData.uid}_$id":"${id}_${userData.uid}";

  static Stream<QuerySnapshot<Map<String, dynamic>>> getallUserChat(ChatUsers user) {
    return firebaseFirestore
        .collection("chatingss/${conversationId(user.id)}/message")
        .snapshots();
  }


  static Future<void> updateProfilePick(File file)async{
    final ext=file.path.split('.').last;
    final ref= firebaseStorage.ref().child("profile_pick/${userData.uid}.$ext");
    await ref.putFile(file,SettableMetadata(contentType: "images/$ext")).then((valu){
      print("kook");
    });
    // print(ref.getDownloadURL());
    me.image=await ref.getDownloadURL();


  }
  static Future<void> sendMessage(ChatUsers user,String message,Type typ)async{
    String time=DateTime.now().millisecondsSinceEpoch.toString();
    ChatModal chatModal=ChatModal(msg: message, read: "", formId: userData.uid, sent: time, told: user.id, type: typ);
    final ref=firebaseFirestore.collection("chatingss/${conversationId(user.id)}/message");
    await ref.doc(time).set(chatModal.toJson());
  }

  static Future<void> updateMessageReadStatus(ChatModal Message, )async{
   try{
     final dateTime=DateTime.now().millisecondsSinceEpoch;
    await firebaseFirestore.collection("chatingss/${conversationId(Message.formId)}/message").doc(Message.sent).update({
       "read":"$dateTime"
     });
   }catch (e){

   }
  }
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(ChatUsers user) {
    return firebaseFirestore
        .collection("chatingss/${conversationId(user.id)}/message").orderBy("sent",descending: true).limit(1)
        .snapshots();
  }

  static Future<void> sendChatUser(ChatUsers user,File file)async{
    final ext=file.path.split('.').last;
  final ref= firebaseStorage.ref().child("images/${conversationId(user.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext");
  await ref.putFile(file,SettableMetadata(contentType: "images/$ext")).then((valu){
    print("kook");
  });
  // print(ref.getDownloadURL());
  final imageUrl=await ref.getDownloadURL();
  await sendMessage(user, imageUrl, Type.image);

  }
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserStatus(ChatUsers user) {
    return firebaseFirestore
        .collection("chats")
        .where("id", isNotEqualTo: userData.uid)
        .snapshots();
  }
  static  forUpdatingTheStatus(bool isOnline) async {
    await firebaseFirestore
        .collection('chats')
        .doc(auth.currentUser!.uid).update({"isOnline":isOnline,'lase_active':DateTime.now().millisecondsSinceEpoch.toString()});

  }
  Future<void> forUpdatingTheTocken() async {
    await firebaseFirestore
        .collection('chats')
        .doc(auth.currentUser!.uid).update({"push_tocken":deviceTocken});

  }
   static Future<void> deleteTheMessage(ChatModal chat)async{
    // final dateTime=DateTime.now().millisecondsSinceEpoch;
    await firebaseFirestore.collection("chatingss/${conversationId(chat.formId)}/message")
        .doc(chat.sent).delete();

    if(chat.type==Type.image){
      await firebaseStorage.refFromURL(chat.told).delete();
    }



  }



}
