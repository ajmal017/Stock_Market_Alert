import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockalerts/DB/DB.dart';
import 'package:stockalerts/Pages/Portfolio_Home.dart';
import 'package:stockalerts/Pages/watchlist.dart';

import 'package:stockalerts/Pages/SignIn.dart';

class FCM {
  final streamCtlr = StreamController<String>.broadcast();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  static Future<dynamic> handleBackgroundMessage(
      Map<String, dynamic> message) async {
    await DB.is_user_exists(DB.email).then((value) => {
          if (value)
            {
              DB
                  .symbol_val(DB.email, message["data"]["symbol"].toString())
                  .then((value) => {
                        if (value == 2)
                          {
                            print("IM"),
                            DB.addNews(DB.email, message),
                          }
                      }),
            }
        });
  }

  Future setNotifications(BuildContext context) async {
    if (Platform.isIOS) {
      _firebaseMessaging
          .requestNotificationPermissions(IosNotificationSettings());
    }
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage1: $message");
        var title = '-';
        var body = '-';
        if (message['data']['title'] != null &&
            message['data']['body'] != null) {
          title = message['data']['title'];
          body = message['data']['body'];
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: ListTile(
                title: Text(title),
                subtitle: Text(body),
              ),
              actions: <Widget>[
                ElevatedButton(
                  child: Text('Ok'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          );
        }

        await handleBackgroundMessage(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch2: $message");
        handleBackgroundMessage(message).then((value) => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LogIn()),
              )
            });
      },
      onResume: (Map<String, dynamic> message) async {
        print("onresume");
        handleBackgroundMessage(message).then((value) => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Porfolio()),
              )
            });
      },
      onBackgroundMessage: (message) => handleBackgroundMessage(message),
    );
    final token = _firebaseMessaging.getToken().then((value) => print(value));
  }
}
