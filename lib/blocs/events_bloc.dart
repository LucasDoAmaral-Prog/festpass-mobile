import 'package:flutter/foundation.dart';

import '../core/models/event.dart';
import '../data/providers/events_data_provider.dart';

class EventsBloc extends ChangeNotifier {
  final EventsDataProvider _provider;
  EventsBloc(this._provider);

  List<EventData> events = const [];
  Set<String> favoriteIds = const {};
  bool loading = false;
  String? error;
  String? _userId;

  Future<void> load(String userId, {String query = ''}) async {
    _userId = userId;
    loading = true;
    error = null;
    notifyListeners();
    try {
      final values = await Future.wait([
        _provider.list(query: query),
        _provider.favoriteIds(userId),
      ]);
      events = values[0] as List<EventData>;
      favoriteIds = values[1] as Set<String>;
    } catch (exception) {
      error = 'Não foi possível carregar os eventos.';
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> search(String query) async {
    final userId = _userId;
    if (userId != null) await load(userId, query: query);
  }

  Future<void> toggleFavorite(String eventId) async {
    final userId = _userId;
    if (userId == null) return;
    final shouldFavorite = !favoriteIds.contains(eventId);
    favoriteIds = {...favoriteIds};
    shouldFavorite ? favoriteIds.add(eventId) : favoriteIds.remove(eventId);
    notifyListeners();
    try {
      await _provider.setFavorite(userId, eventId, shouldFavorite);
    } catch (_) {
      shouldFavorite ? favoriteIds.remove(eventId) : favoriteIds.add(eventId);
      error = 'Não foi possível atualizar o favorito.';
      notifyListeners();
    }
  }

  void clear() {
    _userId = null;
    events = const [];
    favoriteIds = const {};
    notifyListeners();
  }
}
