import 'package:auto_route/auto_route.dart';
import '../pages/home_page.dart'; 
import '../pages/projects_page.dart';
import '../pages/today_page.dart';
import '../pages/week_page.dart';
import '../pages/settings_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(path: '/', page: HomeRoute.page, children: [
      AutoRoute(path: 'projects', page: ProjectsRoute.page),
      AutoRoute(path: 'today', page: TodayRoute.page),
      AutoRoute(path: 'week', page: WeekRoute.page),
      AutoRoute(path: 'settings', page: SettingsRoute.page),
    ]),
  ];
}