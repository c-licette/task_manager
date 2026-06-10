import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'task_repository_impl.dart';
import 'project_repository_impl.dart';
import '../domain/repositories/task_repository.dart';

// Provider pour injecter SharedPreferences
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Doit être initialisé dans le main');
});

// Provider pour le repository
final taskRepositoryProvider = Provider<ITaskRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return TaskRepositoryImpl(prefs);
});

final projectRepositoryProvider = Provider<ProjectRepositoryImpl>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ProjectRepositoryImpl(prefs);
});