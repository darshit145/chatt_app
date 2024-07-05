import 'package:flutter/cupertino.dart';

class MyDateUtil{
  static String getFormatedTime({required BuildContext context,required String time}){
    final date=DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final dateTime=date.hour>12?"${date.hour-12}:${date.minute} pm": "${date.hour}:${date.minute} am";
    return dateTime;

  }
  static String getFormatedTimeAndDate({required String time}){
    final date=DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final now=DateTime.now();
    if(now.day==date.day && now.month==date.month && now.year==date.year){
      final dateTime=date.hour>12?"${date.hour-12}:${date.minute} pm": "${date.hour}:${date.minute} am";
      return dateTime;
    }
    final dateTime="${date.month}/${date.day}";
    return dateTime;


  }

}