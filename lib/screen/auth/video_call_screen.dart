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


import 'package:flutter/material.dart';
class VideoCallScreen extends StatelessWidget {
  const VideoCallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
// ZegoUIKitPrebuiltCall(
// appID: 1301125078,
// appSign: 'your AppSign',
// userID: 'local user id',
// userName: 'local user name',
// callID: 'call id',
// config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
// );
