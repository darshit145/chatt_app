import 'dart:async';
import 'package:chat_app/screen/auth/api.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
class Demo extends StatefulWidget {
  const Demo({super.key});

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> with WidgetsBindingObserver{
  bool _isNear = false;
  late StreamSubscription<dynamic> _streamSubscription;

  @override
  void initState() {
    super.initState();
    print("init Call");
    WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) {
        print("AddPostFreamCallBack");
        Future.delayed(Duration(seconds: 2),(){
          setState(() {
            a=90;
          });
        });
        ScaffoldMessenger.of(context).showSnackBar(r);
      },
    );
    WidgetsBinding.instance.addObserver(this);


    listenSensor();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _streamSubscription.cancel();
  }

  Future<void> listenSensor() async {
    // FlutterError.onError = (FlutterErrorDetails details) {
    //   if (foundation.kDebugMode) {
    //     FlutterError.dumpErrorToConsole(details);
    //   }
    // };
    await ProximitySensor.setProximityScreenOff(false).onError((error, stackTrace) {
      print("could not enable screen off functionality");
      return null;
    });
    _streamSubscription = ProximitySensor.events.listen((int event) {
      setState(() {
        print("sensor");
        print(event);
        _isNear = (event > 0) ? true : false;
      });
    });
  }



  int a=2;
   
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("LLLLLLLLLLLLLLLLLLLLLLLLLLLLLL $state");
    setState(() {
      a++;
    });
    super.didChangeAppLifecycleState(state);

  }
  @override
  Widget build(BuildContext context) {
    print("Build");
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print(Api.me.image);
        },
      ),
      backgroundColor: _isNear? Colors.tealAccent:Colors.red,
      body: Center(
        child: Container(
          height: 200,
            width: 200,
            decoration: BoxDecoration(
              color: Colors.red,
              image: DecorationImage(
                image: NetworkImage(Api.me.image)
              )
            ),
            child: Center(child: Text("$a"))),
      ),
    );
  }
  var r=SnackBar(content: Text("okokok"));
 
}
