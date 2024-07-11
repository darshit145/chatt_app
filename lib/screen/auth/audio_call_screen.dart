import 'package:chat_app/screen/auth/call_integration_apis.dart';
import 'package:chat_app/screen/auth/chat_users.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
class AudioCallScreen extends StatefulWidget {
  String id;
   AudioCallScreen({super.key,required this.id});

  @override
  State<AudioCallScreen> createState() => _AudioCallScreenState();
}

class _AudioCallScreenState extends State<AudioCallScreen> {
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
      callID: widget.id,
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall(),

    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    CallIntegrationApis.updateTheCallInfo(widget.id);
    super.dispose();
  }
}
//
// class AudioCallScreen extends StatelessWidget {
//   ChatUsers user;
//   AudioCallScreen({super.key,required  this.user});
//
//   @override
//   Widget build(BuildContext context) {
//     return ZegoUIKitPrebuiltCall(
//
//       // appID: 1841182921,
//       // // 0c3613f130ec48665cf39250e87e6b54ad1791dcb573d581e4876d2b97ea948a
//       // appSign: '0c3613f130ec48665cf39250e87e6b54ad1791dcb573d581e4876d2b97ea948a',
//       // userID: user.name,
//       // userName: user.id,
//       // callID: "Api.conversationIdForCall",
//       // config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall(),
//       appID: 1841182921,
//       // 0c3613f130ec48665cf39250e87e6b54ad1791dcb573d581e4876d2b97ea948a
//       appSign: '0c3613f130ec48665cf39250e87e6b54ad1791dcb573d581e4876d2b97ea948a',
//       userID: DateTime.now().millisecondsSinceEpoch.toString() ,
//       userName: DateTime.now().toString(),
//       callID: '1212sdc',
//       config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall(),
//
//     );
//   }
// }
