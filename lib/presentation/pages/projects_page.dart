import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../application/project_provider.dart';
import '../../application/task_provider.dart';
import '../../application/search_provider.dart';
import '../../domain/entities/project.dart';
import '../../domain/entities/task.dart';
import '../widgets/task_card.dart';
import '../widgets/task_form.dart';

@RoutePage()
class ProjectsPage extends ConsumerStatefulWidget {
  const ProjectsPage({super.key});

  @override
  ConsumerState<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends ConsumerState<ProjectsPage> {
  String? _selectedProjectId;
@override
Widget build(BuildContext context) {
  final projectsAsync = ref.watch(projectProvider);
  final tasksAsync = ref.watch(taskProvider);

  return projectsAsync.when(
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, _) => Center(child: Text('Erreur : $e')),
    data: (projects) {
      final query = ref.watch(searchQueryProvider).toLowerCase();
      // Aucun projet sélectionné → pleine page centrée
      if (_selectedProjectId == null) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.folder_open, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text('Aucun projet sélectionné',
                  style: TextStyle(fontSize: 18, color: Colors.grey)),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => _showProjectForm(context),
                icon: const Icon(Icons.add),
                label: const Text('Nouveau projet'),
              ),
              if (projects.isNotEmpty) ...[
                const SizedBox(height: 24),
                const Text('Ou choisissez un projet :',
                    style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                ...projects.map((p) => ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color(p.color),
                    radius: 8,
                  ),
                  title: Text(p.name),
                  onTap: () => setState(() => _selectedProjectId = p.id),
                )),
              ],
            ],
          ),
        );
      }

      // Projet sélectionné → layout sidebar + contenu
      return Row(
        children: [
          SizedBox(
            width: 220,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    onPressed: () => _showProjectForm(context),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Nouveau projet'),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: projects.length,
                    itemBuilder: (context, index) {
                      final project = projects[index];
                      final isSelected = _selectedProjectId == project.id;
                      return ListTile(
                        selected: isSelected,
                        leading: CircleAvatar(
                          backgroundColor: Color(project.color),
                          radius: 8,
                        ),
                        title: Text(project.name,
                            style: const TextStyle(fontSize: 13)),
                        onTap: () =>
                            setState(() => _selectedProjectId = project.id),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, size: 16),
                          onPressed: () =>
                              _confirmDeleteProject(context, project),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => setState(() => _selectedProjectId = null),
                ),
                title: Text(
                  projects.firstWhere((p) => p.id == _selectedProjectId).name,
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) =>
                      TaskFormDialog(projectId: _selectedProjectId),
                ),
                child: const Icon(Icons.add),
              ),
              body: tasksAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Erreur : $e')),
                data: (tasks) {
                  final query = ref.watch(searchQueryProvider).toLowerCase();
                  
                  var projectTasks = tasks
                      .where((t) => t.projectId == _selectedProjectId)
                      .toList();

                  if (query.isNotEmpty) {
                    projectTasks = projectTasks.where((t) =>
                      t.title.toLowerCase().contains(query) ||
                      (t.description?.toLowerCase().contains(query) ?? false),
                    ).toList();
                  }

                  if (projectTasks.isEmpty) {
                    return const Center(child: Text('Aucune tâche dans ce projet'));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: projectTasks.length,
                    itemBuilder: (context, index) => TaskCard(task: projectTasks[index]),
                  );
                },
              ),
            ),
          ),
        ],
      );
    },
  );
}

  void _showProjectForm(BuildContext context) {
    final nameCtrl = TextEditingController();
    int selectedColor = Colors.blue.value;

    final colors = [
      Colors.blue, Colors.red, Colors.green, Colors.orange,
      Colors.purple, Colors.teal, Colors.pink, Colors.amber,
    ];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: const Text('Nouveau projet'),
          content: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Nom du projet *'),
                ),
                const SizedBox(height: 16),
                const Text('Couleur :'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: colors.map((c) => GestureDetector(
                    onTap: () => setStateDialog(() => selectedColor = c.value),
                    child: CircleAvatar(
                      backgroundColor: c,
                      radius: 16,
                      child: selectedColor == c.value
                          ? const Icon(Icons.check, color: Colors.white, size: 16)
                          : null,
                    ),
                  )).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameCtrl.text.trim().isEmpty) return;
                ref.read(projectProvider.notifier).addProject(
                  Project(
                    id: const Uuid().v4(),
                    name: nameCtrl.text.trim(),
                    color: selectedColor,
                  ),
                );
                Navigator.pop(context);
              },
              child: const Text('Créer'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteProject(BuildContext context, Project project) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Supprimer le projet'),
        content: Text('Supprimer "${project.name}" et toutes ses tâches ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              ref.read(projectProvider.notifier).deleteProject(project.id);
              if (_selectedProjectId == project.id) {
                setState(() => _selectedProjectId = null);
              }
              Navigator.pop(context);
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}