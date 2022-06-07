import 'package:sqflite/sqflite.dart';

import '../models/task.dart';

/// class responsible for performing all database action
/// inserting, updating, deleting tasks
class DBHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = 'tasks';

  /// initializing database and create it if not exist
  static Future<void> initDB() async {
    if (_db != null) {
      print('Not Null DB');
      return;
    } else {
      try {
        String path = '${await getDatabasesPath()}task.db';
        _db = await openDatabase(path, version: _version,
            onCreate: (Database db, int version) async {
          /// when creating the db, create the table
          print('creating new one');
          await db.execute('CREATE TABLE $_tableName ('
              'id INTEGER PRIMARY KEY AUTOINCREMENT, '
              'title STRING, note TEXT, date STRING, '
              'startTime STRING, endTime STRING, '
              'remind INTEGER, repeat STRING, '
              'color INTEGER, '
              'isCompleted INTEGER'
              ')');
        });
        print('DATABASE created');
      } catch (e) {
        print(e);
      }
    }
  }

  /// retrieve all tasks from database
  static Future<List<Map<String, Object?>>> query() async {
    print('query  function called');
    return await _db!.query(_tableName);
  }

  /// insert task in to database and get its id
  static Future<int> insert(Task? task) async {
    print('insert  function called');
    try {
      return await _db!.insert(_tableName, task!.toJson());
    } catch (e) {
      print('we are here');
      return 90000;
    }
  }

  // static Future<int> update(Task? task) async {
  //   print('update');
  //   return _db!.update(_tableName, task!.toJson());
  // }

  /// update task with specific id and mark as completed
  static Future<int> markTaskAsCompleted(int id) async {
    print('update  function called');
    return _db!.rawUpdate(
        'UPDATE tasks '
        'SET isCompleted = ? '
        'WHERE id = ?',
        [
          1,
          id,
        ]);
  }

  /// delete task from database
  static Future<int> delete(Task? task) async {
    print('delete  function called');
    return _db!.delete(_tableName, where: 'id = ?', whereArgs: [task!.id]);
  }

  /// delete all tasks from database
  static Future<int> deleteAll() async {
    print('delete all function called');
    return _db!.delete(_tableName);
  }
}
