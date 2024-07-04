import 'dart:io';

import 'package:chat_app/screen/auth/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'api.dart';

class LoginnScreen extends StatefulWidget {
  const LoginnScreen({super.key});

  @override
  State<LoginnScreen> createState() => _LoginnScreenState();
}

late double HEIGHT;

class _LoginnScreenState extends State<LoginnScreen> {
  User? _user;
  @override
  void initState() {

    Api.auth.authStateChanges().listen((val) {
      setState(() {
        _user = val;
      });
    });
    super.initState();
    if(FirebaseAuth.instance.currentUser==null){

    }else{
      navigation();
    }
  }
  @override
  Widget build(BuildContext context) {
    HEIGHT = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: HEIGHT * 46 / 100,
            color: Colors.black,
            padding: EdgeInsets.only(top: 100, left: 100),
            child: Image.asset(
              "images/R.png",
            ),
          ),
          Positioned(
              top: 300,
              child: ElevatedButton(
                child: Text("Log in"),
                onPressed: () async {
                  googleSignHandle();
                },
              ))
        ],
      ),
    );
  }

  void googleSignHandle()async {
    try {
      await InternetAddress.lookup("google.com");
      GoogleAuthProvider _provider = GoogleAuthProvider();
       Api.auth.signInWithProvider(_provider).then((value) => Navigator.push(context,MaterialPageRoute(builder: (context) => HomeScreen(),)),);
    } catch (c) {
      final msg=SnackBar(content: Text("please Check Internet"),backgroundColor: Colors.red,);
      ScaffoldMessenger.of(context).showSnackBar(msg);
    }
  }

  void navigation() async {
    if (await Api.userExist()) {
      await Future.delayed(Duration(microseconds: 100));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen(),));
    }
    else {
      await Api.createUser().then((v){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
      });


    }
  }
}
