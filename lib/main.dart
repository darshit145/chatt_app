import 'package:chat_app/demo.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/screen/auth/home_screen.dart';
import 'package:chat_app/screen/auth/incomming_call_screen.dart';
import 'package:chat_app/screen/auth/loginn_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
Future<void> main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.red) );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]) ;




  runApp(const MyApp());

}

void initOneSignal() {
  OneSignal.shared.setAppId("35719def-c861-48a3-ae24-383a0e520291");
  OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
    final data=result.notification.additionalData;
    screen=data?['screenone'];
    if(screen!=null){
      navigatorKey.currentState?.pushNamed(screen!);
    }else {
        // if(data!["isVideo"])
      dataForIncommingCall.add(data!["isVideo"]);
      dataForIncommingCall.add(data!["callerName"]);
      dataForIncommingCall.add(data!["tocken"]);
      navigatorKey.currentState?.pushNamed(data!["navigate"]);
    }

  });
  OneSignal.shared.setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) {
    event.complete(event.notification);

  });

}
List dataForIncommingCall=[];
String? screen;
final navigatorKey=GlobalKey<NavigatorState>();
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    initOneSignal();
    return   MaterialApp(
      navigatorKey: navigatorKey,
      // initialRoute: '/',
      routes: {
        // "/":(context)=>LoginnScreen(),
        '/videocall':(context)=>IncommingCallScreen(infoList: dataForIncommingCall,),
        '/homeScreen':(context)=>HomeScreen(),
      },
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.black,

        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueGrey.shade600,
          centerTitle: true,
          titleTextStyle: TextStyle(color: Colors.white,fontSize: 30)
        )
      ),
      title: '  App',
      debugShowCheckedModeBanner: false,
      home:  LoginnScreen(),
    );
  }
}


//
// import 'package:chat_app/screen/auth/loginn_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/services.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
// import 'firebase_options.dart';
// import 'messaging/firebase_api.dart';
// import 'messaging/firebase_chat_app_messaginc.dart';
// import 'messaging/notification_page.dart';
//
// final navigatorKey = GlobalKey<NavigatorState>();
//
// Future<void> main() async {
//
//
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   FirebaseChatAppMessaginc.forGettingFirebaseMessagingTockon();
//   SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
//   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.red) );
//   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]) ;
//   await FirebaseApi().initNotification();
//   // OneSignal.shared.
//   OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
//   OneSignal.initialize("35719def-c861-48a3-ae24-383a0e520291");
//   OneSignal.Notifications.requestPermission(true);
//
//
//   runApp(const MyApp());
// }
//
// _initiaalizeFirebase()async{
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
// }
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       navigatorKey: navigatorKey,
//       routes: {
//         '/notification_page': (context) => NotificationPage(payload: ''),
//       },
//       showSemanticsDebugger: false,
//       debugShowCheckedModeBanner: false,
//       title: 'Messaging App',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: LoginnScreen(),
//     );
//   }
// }
//
/*


import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() {
  print("ookkook");
  print("ookkook");
  print("ookkook");
  runApp( MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initOneSignal();
    gettingTheOnrId();
  }
  gettingTheOnrId(){
    OneSignal.shared.getDeviceState().then((value){
      print(value?.userId);
      print(value?.userId);
      print(value?.userId);

    });

  }

  void initOneSignal() {
    OneSignal.shared.setAppId("35719def-c861-48a3-ae24-383a0e520291");

    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      print('Notification opened: ${result.notification}');
    });

    OneSignal.shared.setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) {
      print('Notification received in foreground: ${event.notification}');
      event.complete(event.notification);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('OneSignal Notifications'),
        ),
        body: Center(
          child: Text('Waiting for notifications...'),
        ),

        ///fvvefveverververver
      ),
    );
  }
}
*/

/*

import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String playerIdOfUserA = "PLAYER_ID_OF_USER_A"; // Replace with actual Player ID

  @override
  void initState() {
    super.initState();
    initOneSignal();
  }

  void initOneSignal() {
    OneSignal.shared.setAppId("35719def-c861-48a3-ae24-383a0e520291");

    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      // Navigate to OkDk screen when notification is opened

    });

    OneSignal.shared.setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) {
      print('Notification received in foreground: ${event.notification}');
      event.complete(event.notification);
    });

    // Send notification to specific user
    sendNotificationToUser(playerIdOfUserA);

  }

  void sendNotificationToUser(String playerId) {
    var notification = OSCreateNotification(
      appId: "35719def-c861-48a3-ae24-383a0e520291",
      playerId: playerId,
      content: "This is a notification for User A from Flutter",
      heading: "Test Notification", playerIds: [],
    );

    OneSignal.shared.postNotification(notification);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('OneSignal Notifications'),
        ),
        body: Center(
          child: Text('Sending notification to User A...'),
        ),
      ),
    );
  }
}
*/
/*

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? playerIdOfUserA = "PLAYER_ID_OF_USER_A"; // Replace with actual Player ID

  @override
  void initState() {
    super.initState();
    initOneSignal();
  }

  void initOneSignal() {
    OneSignal.shared.setAppId("35719def-c861-48a3-ae24-383a0e520291");

    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {

    });

    OneSignal.shared.setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) {
      print('Notification received in foreground: ${event.notification}');
      event.complete(event.notification);
      OneSignal.shared.getDeviceState().then((deviceState) {
          playerIdOfUserA = deviceState?.userId;
          print(deviceState?.userId);
      });
    });

    // Send notification to specific user
    if(playerIdOfUserA!=null){
      print("PLAYER ID IS ==>$playerIdOfUserA");
      sendNotificationToUser(playerIdOfUserA!);

    }

  }

  void sendNotificationToUser(String playerId) {
    print(playerId);
    var notification = OSCreateNotification(
      // appId: "35719def-c861-48a3-ae24-383a0e520291",
      // playerId: playerId,
      content: "This is a notification for User A from Flutter",
      heading: "Test Notification", playerIds: [],
    );

    OneSignal.shared.postNotification(notification);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            OneSignal.shared.getDeviceState().then((val){
              print(val);
              print(val?.userId);
            });
          },
        ),
        appBar: AppBar(
          title: Text('OneSignal Notifications'),
        ),
        body: Center(
          child: Text('Sending notification to User A...'),
        ),
      ),
    );
  }
}
*/
