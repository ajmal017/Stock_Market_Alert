import 'package:flutter/material.dart';
import 'package:stockalerts/Pages/temp.dart';

void main() async {
  //setupLocator();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        title: "StockAlert",
        home: Temp(),
      ),
    );
  }
}

// class PushNotificationService {
//   final FirebaseMessaging _fcm = FirebaseMessaging();
//   Future init(BuildContext context) async {
//     if (Platform.isIOS) {
//       _fcm.requestNotificationPermissions(IosNotificationSettings());
//     }
//     _fcm.configure(
//       onMessage: (Map<String, dynamic> message) async {
//         print("onMessage1: $message");

//         //NotificationManger.handleNotificationMsg(message);
//       },
//       onLaunch: (Map<String, dynamic> message) async {
//         print("onLaunch2: $message");
//         //NotificationManger.handleDataMsg(message['notification']);
//       },
//       onResume: (Map<String, dynamic> message) async {
//         //NotificationManger.handleDataMsg(message['notification']);
//       },
//     );
//   }
// }
