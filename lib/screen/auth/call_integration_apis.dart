import 'package:chat_app/screen/auth/call_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'api.dart';
import 'chat_users.dart';
class CallIntegrationApis{
  static String callId="";
  static FirebaseFirestore instnt=Api.firebaseFirestore;

  //Updating Call
  static String makeCallLibrary(ChatUsers onlineUser,bool isVideo){
     var myUid= Api.userData;
     callId ="${myUid.uid}${onlineUser.id}";
    final ref=Api.firebaseFirestore.collection("Calls/");
     // {"isVideoCall":isVideo,"from":myUid.uid,"toId":onlineUser.id,"tocken":callId}
     CallModal callModal=CallModal(callId: myUid.uid, connectionLine:callId ,isRightNoe: true, isVideoCall: isVideo, reciverId: onlineUser.id);
    ref.doc(callId).set(callModal.toJson());
    return callId;
  }

  //Getting the call
  static Stream<QuerySnapshot<Map<String, dynamic>>>  getCall(){
    return Api.firebaseFirestore
        .collection("Calls")
        .snapshots();
  }
  static void updateTheCallInfo(String connectionLine){
    Api.firebaseFirestore.collection("Calls").doc(connectionLine).update({
      "isRightNoe":false
    });
  }




}