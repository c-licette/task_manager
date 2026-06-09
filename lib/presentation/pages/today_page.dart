import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/task_provider.dart';
import '../../application/search_provider.dart';
import '../../core/enums.dart';
import '../../domain/entities/task.dart';
import '../widgets/task_form.dart';
import '../widgets/task_card.dart';

@RoutePage()
class TodayPage extends ConsumerWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(newTaskRequestProvider, (_, __) {
      showDialog(context: context, builder: (_) => TaskFormDialog());
    });
    final tasksAsync = ref.watch(taskProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Aujourd'hui")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTaskForm(context, ref),
        child: const Icon(Icons.add),
      ),
      body: tasksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur : $e')),
        data: (tasks) {
          final query = ref.watch(searchQueryProvider).toLowerCase();
          final today = DateTime.now();

          var todayTasks = tasks.where((t) =>
            t.dueDate != null &&
            t.dueDate!.year == today.year &&
            t.dueDate!.month == today.month &&
            t.dueDate!.day == today.day,
          ).toList();

          if (query.isNotEmpty) {
            todayTasks = todayTasks.where((t) =>
              t.title.toLowerCase().contains(query) ||
              (t.description?.toLowerCase().contains(query) ?? false)
            ).toList();
          }

          if (todayTasks.isEmpty) {
            return const Center(child: Text("Aucune tâche pour aujourd'hui"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: todayTasks.length,
            itemBuilder: (context, index) =>
                TaskCard(task: todayTasks[index]),
          );
        },
      ),
    );
  }

  void _showTaskForm(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => TaskFormDialog(),
    );
  }
}