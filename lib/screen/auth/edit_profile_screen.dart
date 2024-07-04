import 'dart:io';

import 'package:chat_app/screen/auth/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../messaging/firebase_chat_app_messaginc.dart';
import '../customclass.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
   File? image;
  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // print(Api.me.image);
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () {

            if(_formKey.currentState!.validate()){
              _formKey.currentState!.save();
              Api.forUpdatingtheUserInfo();

            }
          },
          child: Icon(
            Icons.save,
            color: Colors.white,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        image: image==null? DecorationImage(
                            image:NetworkImage(Api.me.image),
                            fit: BoxFit.fill
                        ):DecorationImage(image: FileImage(image!),
                          fit: BoxFit.fill
                        )
                    ),
                    child:Stack(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.black),
                          child: IconButton(
                            onPressed: () {
                              CustomAlert.alertDialogCustom(
                                  context,
                                  "Select img",
                                  SizedBox(
                                    height: 120,
                                    child: Column(
                                      children: [
                                        ListTile(
                                          onTap: () async{
                                            await imagePicker(ImageSource.camera);
                                            Navigator.pop(context);
                                            print(image);
                                          },
                                          leading: const Icon(Icons.camera),
                                          title: Text("Camera"),
                                        ),
                                        ListTile(
                                          onTap: ()async {
                                            await imagePicker(ImageSource.gallery);
                                            Navigator.pop(context);
                                          },
                                          leading: Icon(Icons.photo),
                                          title: Text("Galary"),
                                        )
                                      ],
                                    ),
                                  ));
                            },
                            icon: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    )
                  )
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  Api.auth.currentUser!.email.toString(),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        onSaved: (newValue) => Api.me.name=newValue??"",
                        validator: (value) {
                          if(value!.isNotEmpty){
                            return null;
                          }
                          return "Enter name";
                        },
                        initialValue:
                             Api.me.name,
                        cursorColor: Colors.black,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person,color: Colors.black,),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          hintText: "Enter name",
                          label: Text(
                            "Name",
                            style: TextStyle(color: Colors.black),
                          ),
                          disabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                        ),
                      ),
                      SizedBox(height: 30,),
                      TextFormField(
                        validator: (value) =>  value!.isNotEmpty?null:"Enter Bio",
                        onSaved: (newValue) => Api.me.about=newValue??"",
                        initialValue:
                        Api.me.about,
                        cursorColor: Colors.black,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person,color: Colors.black,),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.black, width: 2),
                              borderRadius:
                              BorderRadius.all(Radius.circular(10))),
                          hintText: "Update Bio",
                          label: Text(
                            "Bio",
                            style: TextStyle(color: Colors.black),
                          ),
                          disabledBorder: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(10))),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(10))),
                          border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(10))),
                        ),
                      ),

                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  imagePicker(ImageSource source) async {
    final imagePicker = await ImagePicker().pickImage(source: source,imageQuality: 50);
    if (imagePicker == null) return;
    final img = File(imagePicker.path);
    setState(() {
      image = img;
    });
    if(image!=null){
       await Api.updateProfilePick(image!);
    }
  }

}