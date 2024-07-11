import 'package:chat_app/screen/auth/audio_call_screen.dart';
import 'package:chat_app/screen/auth/home_screen.dart';
import 'package:chat_app/screen/auth/video_call_screen.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
class IncommingCallScreen extends StatefulWidget {
  List infoList;
  IncommingCallScreen({super.key,required  this.infoList});

  @override
  State<IncommingCallScreen> createState() => _IncommingCallScreenState();
}
class _IncommingCallScreenState extends State<IncommingCallScreen> {
  @override
  Widget build(BuildContext context) {
    double HEIGH=MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.red.shade100,
      body: Container(
        child: Column(
          children: [
            SizedBox(height: HEIGH*5/100,),
            Text(widget.infoList[0]?"Video Call":"Audio Call",style: TextStyle(color: Colors.black,fontSize: 30,fontWeight: FontWeight.w600),),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircleAvatar(
                    radius: HEIGH*15/120,
                  ),
                  Text(widget.infoList[1],style: TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.w600),),
                  SizedBox(),
                  SizedBox()
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
                    },
                    child: CircleAvatar(radius: 40,backgroundColor: Colors.red,
                      child: Icon(Icons.call_end_sharp,size: 40,color: Colors.white,),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      print(widget.infoList);
                      if(widget.infoList[0]==false){
                        //Audio
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AudioCallScreen(id:widget.infoList[2].toString().trim()),));
                        dataForIncommingCall=[];

                      }else{
                        //vodeo
                        // print(widget.infoList);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VideoCallScreen(callId: widget.infoList[2].toString().trim()),));
                        dataForIncommingCall=[];
                      }

                    },
                    child: CircleAvatar(
                      radius: 40,backgroundColor: Colors.green,
                      child: Icon(Icons.call,size: 40,color: Colors.white,),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
