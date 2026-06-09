// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Project _$ProjectFromJson(Map<String, dynamic> json) => _Project(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  priority:
      $enumDecodeNullable(_$PriorityEnumMap, json['priority']) ??
      Priority.moyenne,
  status: $enumDecodeNullable(_$StatusEnumMap, json['status']) ?? Status.aFaire,
  dueDate: json['dueDate'] == null
      ? null
      : DateTime.parse(json['dueDate'] as String),
  projectId: json['projectId'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$ProjectToJson(_Project instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'priority': _$PriorityEnumMap[instance.priority]!,
  'status': _$StatusEnumMap[instance.status]!,
  'dueDate': instance.dueDate?.toIso8601String(),
  'projectId': instance.projectId,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$PriorityEnumMap = {
  Priority.basse: 'basse',
  Priority.moyenne: 'moyenne',
  Priority.haute: 'haute',
  Priority.urgente: 'urgente',
};

const _$StatusEnumMap = {
  Status.aFaire: 'aFaire',
  Status.enCours: 'enCours',
  Status.terminee: 'terminee',
};
