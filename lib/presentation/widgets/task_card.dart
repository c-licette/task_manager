import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/task_provider.dart';
import '../../core/enums.dart';
import '../../domain/entities/task.dart';
import 'task_form.dart';

class TaskCard extends ConsumerWidget {
  final Task task;
  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: _PriorityIndicator(priority: task.priority),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.status == Status.terminee
                ? TextDecoration.lineThrough
                : null,
          ),
        ),
        subtitle: task.description != null
            ? Text(task.description!, maxLines: 1, overflow: TextOverflow.ellipsis)
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _StatusChip(task: task),
            IconButton(
              icon: const Icon(Icons.edit, size: 18),
              onPressed: () => showDialog(
                context: context,
                builder: (_) => TaskFormDialog(task: task),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 18),
              onPressed: () => _confirmDelete(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Supprimer la tâche'),
        content: Text('Supprimer "${task.title}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              ref.read(taskProvider.notifier).deleteTask(task.id);
              Navigator.pop(context);
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _PriorityIndicator extends StatelessWidget {
  final Priority priority;
  const _PriorityIndicator({required this.priority});

  @override
  Widget build(BuildContext context) {
    final colors = {
      Priority.basse: Colors.green,
      Priority.moyenne: Colors.orange,
      Priority.haute: Colors.red,
      Priority.urgente: Colors.purple,
    };
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: colors[priority],
        shape: BoxShape.circle,
      ),
    );
  }
}

class _StatusChip extends ConsumerWidget {
  final Task task;
  const _StatusChip({required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => _cycleStatus(ref),
      child: Chip(
        label: Text(task.status.label, style: const TextStyle(fontSize: 11)), // ← simplifié
        padding: EdgeInsets.zero,
      ),
    );
  }

  void _cycleStatus(WidgetRef ref) {
    final next = {
      Status.aFaire: Status.enCours,
      Status.enCours: Status.terminee,
      Status.terminee: Status.aFaire,
    };
    ref.read(taskProvider.notifier).updateTask(
      task.copyWith(status: next[task.status]!),
    );
  }
}