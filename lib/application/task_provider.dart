import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/task.dart';
import '../infrastructure/providers.dart';

class TaskNotifier extends AsyncNotifier<List<Task>> {
  @override
  Future<List<Task>> build() async {
    return ref.read(taskRepositoryProvider).getTasks();
  }

  Future<void> addTask(Task task) async {
    await ref.read(taskRepositoryProvider).addTask(task);
    ref.invalidateSelf();
  }

  Future<void> updateTask(Task task) async {
    await ref.read(taskRepositoryProvider).updateTask(task);
    ref.invalidateSelf();
  }

  Future<void> deleteTask(String id) async {
    await ref.read(taskRepositoryProvider).deleteTask(id);
    ref.invalidateSelf();
  }
}

final taskProvider = AsyncNotifierProvider<TaskNotifier, List<Task>>(
  TaskNotifier.new,
);