import 'dart:convert';
import 'dart:io';

import 'package:chat_app/screen/auth/chat_users.dart';
import 'package:chat_app/screen/auth/my_date_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

import '../customclass.dart';
import 'api.dart';
import 'chat_modal.dart';

class ChatScreen extends StatefulWidget {
  ChatUsers user;
  ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  File? image;
  List<ChatModal> chatModalList = [];
  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: StreamBuilder(
          stream: Api.getUserStatus(widget.user),
          builder: (context, snapshot) {
            // final data = snapshot.data?.docs;
            //
            // List<ChatUsers>? jesonDecoded = data?.map((we) {
            //   String jesonEncoded = jsonEncode(we.data());
            //   return ChatUsers.fromJson2(jsonDecode(jesonEncoded));
            // }).toList();
            // if(jesonDecoded==null){
            //   jesonDecoded=[
            //     ChatUsers(isOnline: false, name: "name", id: "id", email: "email", image: "image", createdAt: "createdAt", about: "about", lase_active: "lase_active", push_tocken: "push_tocken")
            //   ];
            // }
            return Row(
              children: [
                Container(
                  width: 50,
                  height: 46,
                  margin: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(32)),
                      image: DecorationImage(
                          image: NetworkImage(widget.user.image),
                          fit: BoxFit.fill)),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.user.name,
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                    Text(
                       widget.user.isOnline?"Online":
                      MyDateUtil.getFormatedTime(context: context, time: widget.user.lase_active),

                      style: TextStyle(fontSize: 15),
                    )
                  ],
                )
              ],
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder(
              stream: Api.getallUserChat(widget.user),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data?.docs;
                  // print(jsonEncode(data!.first.data().toString()));
                  chatModalList = data?.map((ew) {
                        String jesonEncoded = jsonEncode(ew.data());
                        return ChatModal.fromJson2(jsonDecode(jesonEncoded));
                      }).toList() ??
                      [];
                } else {
                  chatModalList = [];
                }

                if (chatModalList.isEmpty) {
                  return Center(
                    child: Text("Say Hi 🤗"),
                  );
                } else {
                  return ListView.builder(
                    reverse: true,
                    itemCount: chatModalList.length,
                    itemBuilder: (context, index) {
                      return ChatMessage(chatModalList[index]);
                    },
                  );
                }
              },
            )),
            chatBox()
          ],
        ),
      ),
    );
  }

  Widget chatBox() {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.emoji_emotions,
                color: Colors.blue,
                size: 30,
              )),
          Expanded(
              child: Container(
            // height: 55,

            child: TextField(
              controller: textEditingController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              cursorColor: Colors.blue,
              decoration: const InputDecoration(
                  hintStyle: TextStyle(color: Colors.blue),
                  hintText: "Type Something..",
                  enabledBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder:
                      OutlineInputBorder(borderSide: BorderSide.none)),
            ),
          )),
          IconButton(
              onPressed: () {
                pickImage();
              },
              icon: Icon(
                Icons.photo,
                color: Colors.blue,
                size: 30,
              )),
          IconButton(
              onPressed: () {
                if (textEditingController.text.isNotEmpty) {
                  Api.sendMessage(widget.user,
                      textEditingController.text.toString(), Type.text);
                  textEditingController.clear();
                }
              },
              icon: Icon(
                Icons.send_sharp,
                color: Colors.blue,
                size: 30,
              ))
        ],
      ),
    );
  }

void pickImage() async {
    CustomAlert.alertDialogCustom(
        context,
        "Select img",
        SizedBox(
          height: 170,
          child: Column(
            children: [
              ListTile(
                onTap: () async {
                  await imagePicker(ImageSource.camera);
                  Navigator.pop(context);
                  print(image);
                },
                leading: const Icon(Icons.camera),
                title: Text("Camera"),
              ),
              ListTile(
                onTap: () async {
                  await imagePicker(ImageSource.gallery);
                  Navigator.pop(context);
                },
                leading: Icon(Icons.photo),
                title: Text("Galary"),
              ),
              ListTile(
                onTap: () async {
                  final imagePicker = await ImagePicker().pickMultiImage(
                      imageQuality: int.parse(textEditingController.text));
                  for (var i in imagePicker) {
                    await Api.sendChatUser(widget.user, File(i.path));
                  }
                  Navigator.pop(context);
                },
                leading: Icon(Icons.image_aspect_ratio_sharp),
                title: Text("Multiple Image"),
              )
            ],
          ),
        ));
  }

  Widget ChatMessage(ChatModal modal) {
    if (modal.read.isEmpty) {
      Api.updateMessageReadStatus(modal);
    }
    bool isMe=Api.userData.uid == modal.formId;

    return InkWell(
      onLongPress: () {
        showModalBottomSheet(context: context, builder: (context) {
          return Column(
            mainAxisSize:MainAxisSize.min ,
            children:isMe? [
              Text("Options",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
              modal.type==Type.image?showBorromSheetOption(onTap: (){},option: "Download  Image",wid: Icon(Icons.download)):showBorromSheetOption(onTap: (){},option: "Copy Text",wid: Icon(Icons.copy)),
              showBorromSheetOption(onTap: (){},option: "Edit Text",wid: Icon(Icons.edit)),
              showBorromSheetOption(onTap: (){},option: "Delete Text",wid: Icon(Icons.delete)),
            ]:[
              Text("Options",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
              modal.type==Type.image?showBorromSheetOption(onTap: (){},option: "Download  Image",wid: Icon(Icons.download)):showBorromSheetOption(onTap: (){},option: "Copy Text",wid: Icon(Icons.copy)),
              showBorromSheetOption(onTap: (){},option: "Delete Text",wid: Icon(Icons.delete)),
              

            ],
          );
        },);
      },

      child:Api.userData.uid == modal.formId
        ? greenMessage(modal)
        : blueMessage(modal));
  }

  Widget greenMessage(ChatModal modal) {
    String date =
        MyDateUtil.getFormatedTime(context: context, time: modal.sent);
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Container(
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 7, right: 7),
              decoration: const BoxDecoration(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(4))),
              child: modal.type == Type.text
                  ? Text(
                      modal.msg,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    )
                  : Container(
                      child: Image.network(modal.msg),
                    ),
            ),
          ),
          Row(
            children: [
              Icon(
                Icons.done_all,
                size: 17,
                color: modal.read.isEmpty ? Colors.black : Colors.blue,
              ),
              SizedBox(
                width: 4,
              ),
              Text(
                date,
                style: TextStyle(color: Colors.black54),
              ),
            ],
          )
        ],
      ),
    );
  }

  //Message Which we recive
  Widget blueMessage(ChatModal modal) {
    print("blutrrrrrrrrrrrrrrrrr");
    if (modal.read.isEmpty) {
      Api.updateMessageReadStatus(modal);
    }

    String date =
        MyDateUtil.getFormatedTime(context: context, time: modal.sent);
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Icon(Icons.done_all,size: 17,color:modal.read.isEmpty?Colors.black: Colors.blue,),
              SizedBox(
                width: 4,
              ),
              Text(
                date,
                style: TextStyle(color: Colors.black54),
              ),
            ],
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 7, right: 7),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(4))),
              child: modal.type == Type.text
                  ? Text(
                      modal.msg,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    )
                  : Container(
                      // height: 200,
                      // width: 200,
                      // decoration: BoxDecoration(
                      //   image: DecorationImage(
                      //     image: NetworkImage(modal.msg)
                      //   ),
                      // ),
                      child: Image.network(modal.msg),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  imagePicker(ImageSource source) async {
    final imagePicker = await ImagePicker().pickImage(
        source: source, imageQuality: int.parse(textEditingController.text));
    if (imagePicker == null) return;
    final img = File(imagePicker.path);

    image = img;

    if (image != null) {
      await Api.sendChatUser(widget.user, image!);
    }
  }
  Widget showBorromSheetOption({required Widget wid,required onTap,required String option}){
    return InkWell(
      onTap: onTap,
      child:ListTile(
        title:  Text(option,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
        leading: wid,

      )
    );
  }
}
