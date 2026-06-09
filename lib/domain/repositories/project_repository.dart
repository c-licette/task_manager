import '../entities/project.dart';

abstract class IProjectRepository {
  Future<List<Project>> getProjects();
  Future<void> addProject(Project project);
  // Ajoutez les méthodes nécessaires selon votre besoin
}