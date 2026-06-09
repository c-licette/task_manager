import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/search_provider.dart';
import '../router/app_router.dart';

@RoutePage()
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AutoTabsScaffold(
      routes: const [
        ProjectsRoute(),
        TodayRoute(),
        WeekRoute(),
        SettingsRoute(),
      ],
      transitionBuilder: (context, child, animation) {
        final tabsRouter = AutoTabsRouter.of(context);
        final searchVisible = ref.watch(searchVisibleProvider);
        final isSettings = tabsRouter.activeIndex == 3;
        return Scaffold(
          appBar: (searchVisible && !isSettings)
              ? AppBar(
                  title: TextField(
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Rechercher une tâche...',
                      border: InputBorder.none,
                    ),
                    onChanged: (value) =>
                        ref.read(searchQueryProvider.notifier).update(value),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        ref.read(searchVisibleProvider.notifier).toggle();
                        ref.read(searchQueryProvider.notifier).update('');
                      },
                    ),
                  ],
                )
              : null,
          body: Row(
            children: [
              NavigationRail(
                selectedIndex: tabsRouter.activeIndex,
                onDestinationSelected: tabsRouter.setActiveIndex,
                destinations: const [
                  NavigationRailDestination(
                      icon: Icon(Icons.folder), label: Text('Projets')),
                  NavigationRailDestination(
                      icon: Icon(Icons.today), label: Text("Aujourd'hui")),
                  NavigationRailDestination(
                      icon: Icon(Icons.date_range),
                      label: Text('Cette semaine')),
                  NavigationRailDestination(
                      icon: Icon(Icons.settings), label: Text('Paramètres')),
                ],
              ),
              Expanded(child: child),
            ],
          ),
        );
      },
    );
  }
}