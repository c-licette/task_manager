import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:task_manager/core/enums.dart';


part 'project.freezed.dart';
part 'project.g.dart';

@freezed
class Project with _$Project {
  const factory Project({
    required String id,
    required String title,
    String? description,
    @Default(Priority.moyenne) Priority priority,
    @Default(Status.aFaire) Status status,
    DateTime? dueDate,
    String? projectId,
    required DateTime createdAt,
  }) = _Project;

  factory Project.fromJson(Map<String, dynamic> json) => _$ProjectFromJson(json);
}