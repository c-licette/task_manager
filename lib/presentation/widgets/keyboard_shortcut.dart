import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/theme_provider.dart';
import '../../application/search_provider.dart';
import 'task_form.dart';

class KeyboardShortcuts extends ConsumerWidget {
  final Widget child;
  const KeyboardShortcuts({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyN):
            const NewTaskIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyF):
            const SearchIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyD):
            const ToggleThemeIntent(),
      },
      child: Actions(
        actions: {
          NewTaskIntent: CallbackAction<NewTaskIntent>(
            onInvoke: (_) {
              ref.read(newTaskRequestProvider.notifier).trigger();  // ← signal
              return null;
            },
          ),
          SearchIntent: CallbackAction<SearchIntent>(
            onInvoke: (_) {
              ref.read(searchVisibleProvider.notifier).toggle();
              return null;
            },
          ),
          ToggleThemeIntent: CallbackAction<ToggleThemeIntent>(
            onInvoke: (_) {
              ref.read(themeProvider.notifier).toggle();
              return null;
            },
          ),
        },
        child: Focus(
          autofocus: true,
          child: child,
        ),
      ),
    );
  }
}

class NewTaskIntent extends Intent {
  const NewTaskIntent();
}

class SearchIntent extends Intent {
  const SearchIntent();
}

class ToggleThemeIntent extends Intent {
  const ToggleThemeIntent();
}