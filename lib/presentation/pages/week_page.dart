import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/task_provider.dart';
import '../../application/search_provider.dart';
import '../widgets/task_card.dart';
import '../widgets/task_form.dart';

@RoutePage()
class WeekPage extends ConsumerWidget {
  const WeekPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(newTaskRequestProvider, (_, _) {
      showDialog(context: context, builder: (_) => TaskFormDialog());
    });
    final tasksAsync = ref.watch(taskProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Cette semaine')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => TaskFormDialog(),
        ),
        child: const Icon(Icons.add),
      ),
      body: tasksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur : $e')),
        data: (tasks) {
          final query = ref.watch(searchQueryProvider).toLowerCase();
          final now = DateTime.now();
          final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
          final endOfWeek = startOfWeek.add(const Duration(days: 6));

          var weekTasks = tasks.where((t) {
            if (t.dueDate == null) return false;
            final d = t.dueDate!;
            return !d.isBefore(DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day)) &&
                   !d.isAfter(DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day, 23, 59));
          }).toList();

          if (query.isNotEmpty) {
            weekTasks = weekTasks.where((t) =>
              t.title.toLowerCase().contains(query) ||
              (t.description?.toLowerCase().contains(query) ?? false)
            ).toList();
          }

          if (weekTasks.isEmpty) {
            return const Center(child: Text('Aucune tâche cette semaine'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: weekTasks.length,
            itemBuilder: (context, index) => TaskCard(task: weekTasks[index]),
          );
        },
      ),
    );
  }
}