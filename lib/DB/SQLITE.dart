import 'package:sqflite/sqflite.dart';

class SQLITE {
  static Future<dynamic> init() async {
    // open the database
    Database database = await openDatabase('user.db', version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS User (key TEXT PRIMARY KEY, value TEXT)');
    });
  }

  static Future<bool> isLoggedIn() async {
    Database database = await openDatabase('user.db', version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS User (key TEXT PRIMARY KEY, value TEXT)');
    });
    var b = await database.rawQuery('Select * from User where key="email"');
    //database.close();
    return b.length > 0 ? true : false;
  }

  static Future<void> login(String email) async {
    Database database = await openDatabase('user.db', version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS User (key TEXT PRIMARY KEY, value TEXT)');
    });
    await database
        .rawInsert('insert into User(key,value) values(?,?)', ['email', email]);
  }

  static Future<void> logout() async {
    Database database = await openDatabase('user.db', version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS User (key TEXT PRIMARY KEY, value TEXT)');
    });
    await database.rawDelete('delete from User where key="email"');
  }

  static Future<String> getusername() async {
    Database database = await openDatabase('user.db', version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS User (key TEXT PRIMARY KEY, value TEXT)');
    });
    var b = await database.rawQuery('Select * from User where key="email"');
    //database.close();
    return b[0]['value'].toString();
    //return b[0].toString();
  }
}
