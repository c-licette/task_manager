import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/infrastructures/providers.dart';
import 'package:task_manager/presentation/router/app_router.dart';
import 'package:window_manager/window_manager.dart';
import 'application/theme_provider.dart';
import 'presentation/widgets/keyboard_shortcut.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  const WindowOptions windowOptions = WindowOptions(
    size: Size(800, 600),
    minimumSize: Size(800, 600),
    title: 'Gestionnaire de Tâches Avancé',
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final isDark = ref.watch(themeProvider);
        return MaterialApp.router(
          title: 'Gestionnaire de Tâches',
          theme: ThemeData(
            colorSchemeSeed: Colors.deepPurple,
            brightness: Brightness.light,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorSchemeSeed: Colors.deepPurple,
            brightness: Brightness.dark,
            useMaterial3: true,
          ),
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          routerConfig: _appRouter.config(
            navigatorObservers:() => [],
          ),
          builder: (context, child) => KeyboardShortcuts(child: child!),
        );
      },
    );
  }
}