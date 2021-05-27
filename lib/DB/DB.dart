import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class DB {
  static String email = 'mashkar';
  static Future<bool> is_user_exists(String name) async {
    final CollectionReference collection =
        Firestore.instance.collection('users');
    bool has = false;
    await collection.document(name).get().then((value) => {
          if (value.exists) {has = true}
        });
    return has;
  }

  static Future<bool> hasSymbol(String username, String symbol) async {
    final DocumentReference collection =
        Firestore.instance.collection('users').document(username);
    bool has = false;
    await collection.get().then((value) => {
          if (value.data['stocks'].containsKey(symbol)) {has = true}
        });
    return has;
  }

  static Future<int> symbol_val(String username, String symbol) async {
    final DocumentReference collection =
        Firestore.instance.collection('users').document(username);
    int val = 0;
    await collection.get().then((value) => {
          val = value.data['stocks'][symbol],
        });
    return val;
  }

  static Future<void> change_symbol_to(
      String username, String symbol, int value) async {
    Map<String, dynamic> map;
    final DocumentReference collection =
        Firestore.instance.collection('users').document(username);
    debugPrint("KK");
    await collection.setData({
      "stocks": {symbol: value}
    }, merge: true);
  }

  static Future<List> filterSymbols(String username, int filter) async {
    List filtered = [];
    final DocumentReference collection =
        Firestore.instance.collection('users').document(username);

    await collection.get().then((value) => {
          value.data['stocks'].forEach((key, value) {
            if (value >= filter) {
              filtered.add(key);
            }
          }),
        });
    return filtered;
  }

  static Future<void> addNews(
      String username, Map<String, dynamic> message) async {
    final DocumentReference collection =
        Firestore.instance.collection('users').document(username);
    debugPrint("OKK->INDB");

    print(message);
    await collection.setData({
      "news": {
        DateTime.now().millisecondsSinceEpoch.toString(): {
          "symbol": message['data']['symbol'],
          "title": message['data']['title'],
          "body": message['data']['body'],
        }
      }
    }, merge: true);
  }

  static Future<List> getnews(String username) async {
    List filtered = [];
    final DocumentReference collection =
        Firestore.instance.collection('users').document(username);

    await collection.get().then((value) => {
          value.data['news'].forEach((key, value) {
            print(key);
            var datetime = DateTime.fromMillisecondsSinceEpoch(int.parse(key));

            filtered.add({
              "title": value["title"],
              "body": value['body'],
              "time": datetime.year.toString() +
                  "-" +
                  datetime.month.toString() +
                  "-" +
                  datetime.day.toString()
            });
          }),
        });
    return filtered;
  }

  static Future<dynamic> signup(
      String name, String email, String password) async {
    print(name);
    final CollectionReference collection =
        Firestore.instance.collection('users');
    bool stat = true;
    await collection.document(email).get().then((value) => {
          if (value.exists)
            {
              stat = false,
            }
        });
    if (!stat) return false;

    await collection.document(email).setData({
      "name": name,
      "email": email,
      "password": password,
      "news": [],
      "stocks": []
    });

    return stat;
  }

  static Future<dynamic> login(String email, String password) async {
    print(email);
    final CollectionReference collection =
        Firestore.instance.collection('users');
    bool stat = true;
    await collection.document(email).get().then((value) => {
          if (!value.exists)
            {
              stat = false,
            }
        });

    if (!stat) return false;

    await collection.document(email).get().then((value) => {
          if (value.data['password'] != password)
            {
              stat = false,
            }
        });
    if (!stat) return false;

    return stat;
  }
}
