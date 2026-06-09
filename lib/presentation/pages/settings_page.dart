import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/theme_provider.dart';

@RoutePage()
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Mode sombre'),
            subtitle: const Text('Basculer entre thème clair et sombre'),
            value: isDark,
            onChanged: (_) => ref.read(themeProvider.notifier).toggle(),
          ),
          const Divider(height: 32),
          Text(
            'Raccourcis clavier',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          _ShortcutTile(
            keys: 'Ctrl + N',
            description: 'Créer une nouvelle tâche',
          ),
          _ShortcutTile(
            keys: 'Ctrl + F',
            description: 'Ouvrir / fermer la recherche',
          ),
          _ShortcutTile(
            keys: 'Ctrl + D',
            description: 'Basculer le thème clair / sombre',
          ),
        ],
      ),
    );
  }
}


class _ShortcutTile extends StatelessWidget {
  final String keys;
  final String description;

  const _ShortcutTile({required this.keys, required this.description});

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurface.withOpacity(0.45);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.4),
              ),
            ),
            child: Text(
              keys,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                color: muted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            description,
            style: TextStyle(fontSize: 14, color: muted),
          ),
        ],
      ),
    );
  }
}