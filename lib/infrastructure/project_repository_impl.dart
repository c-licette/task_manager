import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/entities/project.dart';
import '../domain/repositories/project_repository.dart';

class ProjectRepositoryImpl implements IProjectRepository {
  final SharedPreferences prefs;
  static const String _key = 'projects_data';

  ProjectRepositoryImpl(this.prefs);

  @override
  Future<List<Project>> getProjects() async {
    final data = prefs.getString(_key);
    if (data == null) return [];
    final List<dynamic> jsonList = jsonDecode(data);
    return jsonList.map((j) => Project.fromJson(j)).toList();
  }

  @override
  Future<void> addProject(Project project) async {
    final projects = await getProjects();
    projects.add(project);
    await _save(projects);
  }

@override
  Future<void> updateProject(Project project) async {
    final projects = await getProjects();
    final index = projects.indexWhere((p) => p.id == project.id);
    if (index != -1) {
      projects[index] = project;
      await _save(projects);
    }
  }

  @override 
  Future<void> deleteProject(String id) async {
    final projects = await getProjects();
    projects.removeWhere((p) => p.id == id);
    await _save(projects);
  }


  Future<void> _save(List<Project> projects) async {
    final data = jsonEncode(projects.map((p) => p.toJson()).toList());
    await prefs.setString(_key, data);
  }
}