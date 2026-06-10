import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements ITaskRepository {
  final SharedPreferences prefs;
  static const String _key = 'tasks_data';

  TaskRepositoryImpl(this.prefs);

  @override
  Future<List<Task>> getTasks() async {
    final String? data = prefs.getString(_key);
    if (data == null) return [];
    final List<dynamic> jsonList = jsonDecode(data);
    return jsonList.map((json) => Task.fromJson(json)).toList();
  }

  @override
  Future<void> addTask(Task task) async {
    final tasks = await getTasks();
    tasks.add(task);
    await _save(tasks);
  }

  @override
  Future<void> updateTask(Task task) async {
    final tasks = await getTasks();
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      tasks[index] = task;
      await _save(tasks);
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    final tasks = await getTasks();
    tasks.removeWhere((t) => t.id == id);
    await _save(tasks);
  }

  Future<void> _save(List<Task> tasks) async {
    final String data = jsonEncode(tasks.map((t) => t.toJson()).toList());
    await prefs.setString(_key, data);
  }
}