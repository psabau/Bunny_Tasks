import 'package:get/get.dart';
import 'db_config.dart';
import 'task.dart';

class TaskController extends GetxController {

  @override
  void onReady() {
    getTasks();
    super.onReady();
  }

  final RxList<Task> taskList = List<Task>.empty().obs;

  Future<void> addTask({required Task task}) async {
    await DBConfig.insert(task);
  }

  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DBConfig.query();
    taskList.assignAll(tasks.map((data) => new Task.fromJson(data)).toList());
  }

  void deleteTask(Task task) async {
    await DBConfig.delete(task);
    getTasks();
  }

  void markTaskCompleted(int? id) async {
    await DBConfig.update(id);
    getTasks();
  }
}