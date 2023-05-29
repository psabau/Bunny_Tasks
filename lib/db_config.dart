import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'task.dart';

class DBConfig {
  static Database? myDatabase;
  static final int myVersion = 2;
  static final String myTable = 'tasks5';

  static Future<void> initDb() async {
    if (myDatabase != null) {
      debugPrint("not null db");
      return;
    }
    try {
      String _path = await getDatabasesPath() + 'tasks5.db';
      debugPrint("in database path");
      myDatabase = await openDatabase(
        _path,
        version: myVersion,
        onCreate: (db, version) {
          debugPrint("creating a new one");
          return db.execute(
            "CREATE TABLE $myTable("
                "id INTEGER PRIMARY KEY AUTOINCREMENT, "
                "title STRING, note TEXT, date STRING, "
                "startTime STRING, endTime STRING, "
                "remind INTEGER, repeat STRING, "
                "color INTEGER, "
                "isCompleted INTEGER)",
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  static Future<int> insert(Task task) async {
    print("insert function called");
    return await myDatabase!.insert(myTable, task.toJson());
  }
  static Future<int> delete(Task task) async =>
      await myDatabase!.delete(myTable, where: 'id = ?',
          whereArgs: [task.id]);

  static Future<List<Map<String, dynamic>>> query() async {
    print("query function called");
    return myDatabase!.query(myTable);
  }
  static Future<int> update(int? id) async {
    print("update function called");
    return await myDatabase!.rawUpdate('''
    UPDATE tasks   
    SET isCompleted = ?
    WHERE id = ?
    ''', [1, id]);
  }
}
