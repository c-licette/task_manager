import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../infrastructure/providers.dart';

class ThemeNotifier extends Notifier<bool> {
  static const _key = 'dark_mode';

  @override
  bool build() {
    final prefs = ref.read(sharedPreferencesProvider);
    return prefs.getBool(_key) ?? false;
  }

  void toggle() {
    final prefs = ref.read(sharedPreferencesProvider);
    state = !state;
    prefs.setBool(_key, state);
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, bool>(
  ThemeNotifier.new,
);