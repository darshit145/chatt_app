import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAlert{
  static alertDialog(BuildContext context,String content){
    return showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text("Some Error"),
        content: Text("$content",style: TextStyle(fontSize: 12),),
      );
    },);
  }
  static alertDialogCustom(BuildContext context,String data,Widget content,[act=null]){
    return showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text("$data"),
        content: content,
        actions: act,
      );
    },);
  }
}