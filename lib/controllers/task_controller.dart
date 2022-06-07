import 'package:get/get.dart';
import 'package:todo/db/db_helper.dart';

import '../models/task.dart';

/// GetX controller class responsible for all main action in database
/// and link between database action class and ui
class TaskController extends GetxController {
  final RxList<Task> taskList = RxList.empty(growable: true);

  /// retrieve all tasks from database and update task list to update ui
  Future<void> getTasks() async {
    var result = await DBHelper.query();
    taskList.assignAll(result.map((e) => Task.fromJson(e)).toList());
  }

  /// add task into database
  Future<int> addTask({Task? task}) {
    return DBHelper.insert(task);
  }

  /// mark specific task as completed and update ui
  Future<void> markTaskAsCompleted({Task? task}) async {
    await DBHelper.markTaskAsCompleted(task!.id!);
    getTasks();
  }

  /// delete specific task and update ui
  Future<void> deleteTask({Task? task}) async {
    await DBHelper.delete(task);
    getTasks();
  }

  /// delete all tasks
  Future<void> deleteAllTasks() async {
    await DBHelper.deleteAll();
    getTasks();
  }
}
