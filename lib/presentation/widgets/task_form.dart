import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../application/task_provider.dart';
import '../../core/enums.dart';
import '../../domain/entities/task.dart';

class TaskFormDialog extends ConsumerStatefulWidget {
  final Task? task;
  final String? projectId; 
  const TaskFormDialog({super.key, this.task, this.projectId});

  @override
  ConsumerState<TaskFormDialog> createState() => _TaskFormDialogState();
}

class _TaskFormDialogState extends ConsumerState<TaskFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;
  late Priority _priority;
  late Status _status;
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.task?.title ?? '');
    _descCtrl = TextEditingController(text: widget.task?.description ?? '');
    _priority = widget.task?.priority ?? Priority.moyenne;
    _status = widget.task?.status ?? Status.aFaire;
    _dueDate = widget.task?.dueDate;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.task != null;
    return AlertDialog(
      title: Text(isEdit ? 'Modifier la tâche' : 'Nouvelle tâche'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: 'Titre *'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Titre requis' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 2,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<Priority>(
                value: _priority,
                decoration: const InputDecoration(labelText: 'Priorité'),
                items: Priority.values.map((p) => DropdownMenuItem(
                  value: p,
                  child: Text(p.label),
                )).toList(),
                onChanged: (v) => setState(() => _priority = v!),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<Status>(
                value: _status,
                decoration: const InputDecoration(labelText: 'Statut'),
                items: Status.values.map((s) => DropdownMenuItem(
                  value: s,
                  child: Text(s.label),
                )).toList(),
                onChanged: (v) => setState(() => _status = v!),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(_dueDate == null
                      ? 'Pas de date d\'échéance'
                      : 'Échéance : ${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}'),
                  const Spacer(),
                  TextButton(
                    onPressed: _pickDate,
                    child: const Text('Choisir'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: Text(isEdit ? 'Modifier' : 'Créer'),
        ),
      ],
    );
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (date != null) setState(() => _dueDate = date);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final task = widget.task?.copyWith(
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
      priority: _priority,
      status: _status,
      dueDate: _dueDate,
    ) ?? Task(
      id: const Uuid().v4(),
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
      priority: _priority,
      status: _status,
      dueDate: _dueDate,
      projectId: widget.projectId,
      createdAt: DateTime.now(),
    );

    if (widget.task != null) {
      ref.read(taskProvider.notifier).updateTask(task);
    } else {
      ref.read(taskProvider.notifier).addTask(task);
    }
    Navigator.pop(context);
  }
}