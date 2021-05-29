import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stockalerts/DB/DB.dart';
import 'package:stockalerts/DB/SQLITE.dart';

import 'package:stockalerts/Pages/Portfolio_Home.dart';
import 'package:stockalerts/Pages/SignIn.dart';
import 'package:stockalerts/Services/PushNotificationService.dart';
import 'package:stockalerts/locator.dart';
import 'package:stockalerts/main.dart';
import 'package:stockalerts/main.dart';

class Temp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SQLITE.init();
    // SQLITE.isLoggedIn().then((value) => print(value));
    // SQLITE.logout();
    // SQLITE.isLoggedIn().then((value) => print(value));
    // //SQLITE.login("mashkarharis@gmail.com");
    // SQLITE.isLoggedIn().then((value) => print(value));
    // print("%%%%%%%%%%%%%");
    // //SQLITE.getusername().then((value) => print(value));

    FCM firebaseMessaging = FCM();
    firebaseMessaging.setNotifications(context);
    firebaseMessaging.streamCtlr.stream.listen((msgData) {
      //_changeMsg(msgData);
    });
    //Run(context);

    return Scaffold(
      backgroundColor: const Color(0xff010114),
      body: Container(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  SizedBox(
                    height: 300,
                  ),
                  Text("TradePick4U",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold)),
                  Container(
                    color: const Color(0xff010114),
                    child: Column(
                      children: [
                        Container(
                          height: 100,
                          color: const Color(0xff010114),
                          child: Image.network(
                              'https://cdn.pixabay.com/photo/2013/07/12/14/07/bag-147782_960_720.png'),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    child: Text(
                      "Let's Begin",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () => {
                      SQLITE.isLoggedIn().then(
                            (value) => {
                              if (value)
                                {
                                  SQLITE.getusername().then(
                                        (email) => {
                                          DB.email = email,
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Porfolio()),
                                          )
                                        },
                                      )
                                }
                              else
                                {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LogIn()),
                                  )
                                }
                            },
                          )
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
