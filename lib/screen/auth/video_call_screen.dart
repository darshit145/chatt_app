// import 'package:chat_app/screen/auth/chat_users.dart';
// import 'package:flutter/material.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
// class VideoCallScreenFor extends StatefulWidget {
//   ChatUsers user;
//     VideoCallScreen({super.key,required this.user});
//
//   @override
//   State<VideoCallScreen> createState() => _VideoCallScreenState();
// }
//
// class _VideoCallScreenState extends State<VideoCallScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return ZegoUIKitPrebuiltCall(
//       appID:  1301125078, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
//       appSign: "942b1c880efd364ed5c52246c6671301ecff3613e7e75edb4a1fb9e749831720", // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
//       userID: widget.user.id,
//       userName: widget.user.name,
//       callID: "same",
//       config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
//     );
//   }
// }
import 'package:chat_app/screen/auth/chat_users.dart';
import "package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart";
import 'package:flutter/material.dart';

import 'api.dart';
class VideoCallScreen extends StatelessWidget {
  ChatUsers user;
  VideoCallScreen({super.key,required this.user});

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(

      appID: 1841182921,
      // 0c3613f130ec48665cf39250e87e6b54ad1791dcb573d581e4876d2b97ea948a
      appSign: '0c3613f130ec48665cf39250e87e6b54ad1791dcb573d581e4876d2b97ea948a',
      userID: user.name,
      userName: user.id,
      callID: "Api.conversationIdForCall",
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
    );

  }
}
