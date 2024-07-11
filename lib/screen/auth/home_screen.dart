import 'dart:convert';
import 'package:chat_app/demo.dart';
import 'package:chat_app/screen/auth/api.dart';
import 'package:chat_app/screen/auth/chat_modal.dart';
import 'package:chat_app/screen/auth/chat_screen.dart';
import 'package:chat_app/screen/auth/chat_users.dart';
import 'package:chat_app/screen/auth/edit_profile_screen.dart';
import 'package:chat_app/screen/auth/my_date_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../../messaging/firebase_chat_app_messaginc.dart';
import 'call_integration_apis.dart';
import 'check_incomming_call.dart';
import 'loginn_screen.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    OneSignal.shared.getDeviceState().then((val){
      deviceTocken=val?.userId??"NO";
      callingTheCurrentUser();
    });
    Api.forUpdatingTheStatus(true);
    super.initState();
    callingTheCurrentUser();
    SystemChannels.lifecycle.setMessageHandler((message) {
      if (message.toString().contains("resume")) Api.forUpdatingTheStatus(true);
      if (message.toString().contains("pause")) Api.forUpdatingTheStatus(false);
      return Future.value(message);
    });
  }

  void callingTheCurrentUser() async {
    await Api.getCurrentInfo();
    Api obj = Api();
    obj.forUpdatingTheTocken().then((d) {
      print("Tocken Updated..");
    });
  }

  List<ChatUsers> users = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          // print(Api.userData.uid);
          // CallIntegrationApis.makeCallLibrary();
          Navigator.push(context, MaterialPageRoute(builder: (context) => CheckIncommingCall(),));

        },
        child: Icon(
          Icons.chat_outlined,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfileScreen(),
                    ));
              },
              icon: Icon(
                Icons.edit,
                size: 20,
              )),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Demo(),
                    ));
              },
              icon: Icon(Icons.add)),
          TextButton(
              onPressed: () async {
                Api.forUpdatingTheStatus(false);
                await Api.auth.signOut();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginnScreen(),
                    ));
              },
              child: Text(
                "Log Out",
                style: TextStyle(color: Colors.black),
              ))
        ],
        automaticallyImplyLeading: false,
        title: Text("Hello"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: StreamBuilder(
          stream: Api.getallUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data!.docs;
              users = data.map((e) {
                String jesonEncoded = jsonEncode(e.data());
                return ChatUsers.fromJson2(jsonDecode(jesonEncoded));
              }).toList();
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return CustomCard(users[index], context);
                },
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

Widget CustomCard(ChatUsers obj, BuildContext context) {
  return StreamBuilder(
    stream: Api.getLastMessage(obj),
    builder: (context, snapshot) {
      late ChatModal chatModal;
      bool isFirstUser = false;
      try {
        final data = snapshot.data?.docs;
        var r = data?.map((e) {
          String? jesonEncoded = jsonEncode(e.data());
          return jsonDecode(jesonEncoded);
        });
        chatModal = ChatModal.fromJson2(r?.first);
        print(chatModal.type);
      } catch (e) {
        isFirstUser = true;
      }

      return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(user: obj),
              ));
        },
        child: ListTile(
          title: Text(obj.name),
          subtitle: Text(isFirstUser
              ? obj.email
              : chatModal.type == Type.text
                  ? chatModal.msg
                  : "image"),
          leading: Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(23)),
                image: DecorationImage(
                    image: NetworkImage(obj.image), fit: BoxFit.fill)),
          ),
          trailing: isFirstUser
              ? Text("")
              : chatModal.formId == Api.userData.uid
                  ? Text(
                      MyDateUtil.getFormatedTimeAndDate(time: chatModal.sent))
                  : CircleAvatar(
                      radius: 2,
                      backgroundColor: Colors.green,
                    ),
        ),
      );
    },
  );
}

Future<void> sendNotification(String content,String senderId,String senderName) async {
  var headers = {
    'Content-Type': 'application/json; charset=utf-8',
    'Authorization': "Basic NTcyN2UxMTItNDBmZS00NzhiLTkyNzMtNDNmZGFkYzM0YWMx",
  };

  var body = json.encode({
    "app_id": "35719def-c861-48a3-ae24-383a0e520291",
    "include_player_ids": [
      senderId,
      // "bee668d7-9482-49e6-8241-0784673703dd",
      // "2c60b96d-6349-4881-85b7-ee31c2c3b999"
    ],
    "headings": {"en": "$senderName"},
    "contents": {"en": "$content"},
    "data": {
      "screenone": "/homeScreen",
    }
  });

  var response = await http.post(
    Uri.parse('https://onesignal.com/api/v1/notifications'),
    headers: headers,
    body: body,
  );

  if (response.statusCode == 200) {
    print('Notification sent successfully');
  } else {
    print('Failed to send notification: ${response.body}');
  }
}

Future<void> sendNotificationFroCall(String content,String senderId,String senderName,bool isVideo,String callerName,String tocken) async {
  var headers = {
    'Content-Type': 'application/json; charset=utf-8',
    'Authorization': "Basic NTcyN2UxMTItNDBmZS00NzhiLTkyNzMtNDNmZGFkYzM0YWMx",
  };

  var body = json.encode({
    "app_id": "35719def-c861-48a3-ae24-383a0e520291",
    "include_player_ids": [
      senderId,
      // "bee668d7-9482-49e6-8241-0784673703dd",
      // "2c60b96d-6349-4881-85b7-ee31c2c3b999"
    ],
    "headings": {"en": "$senderName"},
    "contents": {"en": "$content"},
    "data": {

      "navigate": "/videocall",
      "tocken":tocken,
      "callerName":callerName,
      "isVideo":isVideo
    }

  });

  var response = await http.post(
    Uri.parse('https://onesignal.com/api/v1/notifications'),
    headers: headers,
    body: body,
  );

  if (response.statusCode == 200) {
    print('Notification sent successfully');
  } else {
    print('Failed to send notification: ${response.body}');
  }
}