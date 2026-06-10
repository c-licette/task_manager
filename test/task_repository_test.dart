import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/domain/entities/task.dart';
import 'package:task_manager/domain/repositories/task_repository.dart';
import 'package:task_manager/application/task_provider.dart';
import 'package:task_manager/infrastructure/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/core/enums.dart';

import 'task_repository_test.mocks.dart';

@GenerateMocks([ITaskRepository])
void main() {
  // Test 1 — comportement du repository mocké
  group('ITaskRepository mock', () {
    late MockITaskRepository mockRepo;

    setUp(() {
      mockRepo = MockITaskRepository();
    });

    test('getTasks retourne une liste de tâches', () async {
      final fakeTasks = [
        Task(
          id: '1',
          title: 'Tâche test',
          priority: Priority.moyenne,
          status: Status.aFaire,
          createdAt: DateTime(2024, 1, 1),
        ),
      ];

      when(mockRepo.getTasks()).thenAnswer((_) async => fakeTasks);

      final result = await mockRepo.getTasks();

      expect(result, isA<List<Task>>());
      expect(result.length, 1);
      expect(result.first.title, 'Tâche test');
      verify(mockRepo.getTasks()).called(1);
    });

    test('addTask appelle bien le repository', () async {
      final task = Task(
        id: '2',
        title: 'Nouvelle tâche',
        priority: Priority.haute,
        status: Status.aFaire,
        createdAt: DateTime(2024, 1, 1),
      );

      when(mockRepo.addTask(task)).thenAnswer((_) async {});

      await mockRepo.addTask(task);

      verify(mockRepo.addTask(task)).called(1);
    });

    test('deleteTask appelle bien le repository avec le bon id', () async {
      when(mockRepo.deleteTask('1')).thenAnswer((_) async {});

      await mockRepo.deleteTask('1');

      verify(mockRepo.deleteTask('1')).called(1);
    });
  });

  // Test 2 — provider avec ProviderContainer et overrides
  group('TaskProvider avec ProviderContainer', () {
    late MockITaskRepository mockRepo;

    setUp(() {
      mockRepo = MockITaskRepository();
    });

    test('taskProvider charge les tâches initiales', () async {
      final fakeTasks = [
        Task(
          id: '1',
          title: 'Tâche provider',
          priority: Priority.basse,
          status: Status.enCours,
          createdAt: DateTime(2024, 1, 1),
        ),
      ];

      when(mockRepo.getTasks()).thenAnswer((_) async => fakeTasks);

      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          taskRepositoryProvider.overrideWithValue(
            mockRepo,
          ),
        ],
      );

      addTearDown(container.dispose);

      final result = await container.read(taskProvider.future);

      expect(result, isA<List<Task>>());
      expect(result.first.title, 'Tâche provider');
    });

    test('taskProvider ajoute une tâche', () async {
      final task = Task(
        id: '3',
        title: 'Tâche ajoutée',
        priority: Priority.urgente,
        status: Status.aFaire,
        createdAt: DateTime(2024, 1, 1),
      );

      when(mockRepo.getTasks()).thenAnswer((_) async => [task]);
      when(mockRepo.addTask(any)).thenAnswer((_) async {});

      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          taskRepositoryProvider.overrideWithValue(
            mockRepo,
          ),
        ],
      );

      addTearDown(container.dispose);

      await container.read(taskProvider.notifier).addTask(task);
      final result = await container.read(taskProvider.future);

      expect(result.any((t) => t.title == 'Tâche ajoutée'), true);
    });
  });
}