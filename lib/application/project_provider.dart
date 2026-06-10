import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/project.dart';
import '../infrastructure/providers.dart';

class ProjectNotifier extends AsyncNotifier<List<Project>> {
  @override
  Future<List<Project>> build() async {
    return ref.read(projectRepositoryProvider).getProjects();
  }

  Future<void> addProject(Project project) async {
    await ref.read(projectRepositoryProvider).addProject(project);
    ref.invalidateSelf();
  }

  Future<void> updateProject(Project project) async {
    await ref.read(projectRepositoryProvider).updateProject(project);
    ref.invalidateSelf();
  }

  Future<void> deleteProject(String id) async {
    await ref.read(projectRepositoryProvider).deleteProject(id);
    ref.invalidateSelf();
  }
}

final projectProvider = AsyncNotifierProvider<ProjectNotifier, List<Project>>(
  ProjectNotifier.new,
);