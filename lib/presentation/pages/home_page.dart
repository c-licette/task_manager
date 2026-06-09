import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/presentation/router/app_router.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: const [
        ProjectsRoute(),
        TodayRoute(),
        WeekRoute(),
        SettingsRoute(),
      ],
      transitionBuilder: (context, child, animation) {
        final tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
          body: Row(
            children: [
              NavigationRail(
                selectedIndex: tabsRouter.activeIndex,
                onDestinationSelected: tabsRouter.setActiveIndex,
                destinations: const [
                  NavigationRailDestination(icon: Icon(Icons.folder), label: Text('Projets')),
                  NavigationRailDestination(icon: Icon(Icons.today), label: Text("Aujourd'hui")),
                  NavigationRailDestination(icon: Icon(Icons.date_range), label: Text('Cette semaine')),
                  NavigationRailDestination(icon: Icon(Icons.settings), label: Text('Paramètres')),
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