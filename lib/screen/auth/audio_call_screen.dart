import 'package:chat_app/screen/auth/chat_users.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
class AudioCallScreen extends StatelessWidget {
  ChatUsers user;
  AudioCallScreen({super.key,required  this.user});

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(

      // appID: 1841182921,
      // // 0c3613f130ec48665cf39250e87e6b54ad1791dcb573d581e4876d2b97ea948a
      // appSign: '0c3613f130ec48665cf39250e87e6b54ad1791dcb573d581e4876d2b97ea948a',
      // userID: user.name,
      // userName: user.id,
      // callID: "Api.conversationIdForCall",
      // config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall(),
      appID: 1841182921,
      // 0c3613f130ec48665cf39250e87e6b54ad1791dcb573d581e4876d2b97ea948a
      appSign: '0c3613f130ec48665cf39250e87e6b54ad1791dcb573d581e4876d2b97ea948a',
      userID: DateTime.now().millisecondsSinceEpoch.toString() ,
      userName: DateTime.now().toString(),
      callID: '1212sdc',
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall(),

    );
  }
}
