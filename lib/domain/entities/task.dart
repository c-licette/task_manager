import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:task_manager/core/enums.dart';

part 'task.freezed.dart';
part 'task.g.dart';         

@freezed
abstract class Task with _$Task {
  const factory Task({
    required String id,
    required String title,
    String? description,
    @Default(Priority.moyenne) Priority priority,
    @Default(Status.aFaire) Status status,
    DateTime? dueDate,
    String? projectId,
    required DateTime createdAt,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}