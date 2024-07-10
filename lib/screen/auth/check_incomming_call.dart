import 'dart:convert';

import 'package:chat_app/demo.dart';
import 'package:chat_app/screen/auth/call_integration_apis.dart';
import 'package:chat_app/screen/auth/call_modal.dart';
import 'package:chat_app/screen/auth/loginn_screen.dart';
import 'package:flutter/material.dart';
class CheckIncommingCall extends StatefulWidget {
  const CheckIncommingCall({super.key});

  @override
  State<CheckIncommingCall> createState() => _CheckIncommingCallState();
}

class _CheckIncommingCallState extends State<CheckIncommingCall> {
  List<CallModal> calls=[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: CallIntegrationApis.getCall(),
        builder: (context, snapshot) {

          if(snapshot.hasData){
            final data= snapshot.data!.docs;
            calls =data.map((value){
              String jesonEncoded=jsonEncode(value.data());
              return CallModal.fromJson(jsonDecode(jesonEncoded));
            }).toList();
            for(var demm in calls){
              if(demm.isRightNoe==true){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Demo(),));
              }
            }
            return ListView.builder(
                itemBuilder:  (context, index) {
                  if(calls[index].isRightNoe==true){
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => Demo(),));

                  }
                  return ListTile(
                    title: Text(calls[index].callId.toString()),
                    subtitle: Text(calls[index].reciverId),

                  );
                },
              itemCount: calls.length,
            );
          }
          return CircularProgressIndicator();


        },
      ),
    );
  }
}
