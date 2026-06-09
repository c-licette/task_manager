import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void toggle() => state = !state;
}

class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void update(String query) => state = query;
}

class NewTaskRequestNotifier extends Notifier<int> {
  @override
  int build() => 0;
  void trigger() => state++;
}

final searchVisibleProvider = NotifierProvider<SearchNotifier, bool>(
  SearchNotifier.new,
);
final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(
  SearchQueryNotifier.new,
);

final newTaskRequestProvider = NotifierProvider<NewTaskRequestNotifier, int>(
  NewTaskRequestNotifier.new,
);