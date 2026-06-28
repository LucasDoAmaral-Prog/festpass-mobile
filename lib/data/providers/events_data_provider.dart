import '../../core/models/event.dart';
import 'firebase_service.dart';

class EventsDataProvider {
  final FirebaseService _firebase;
  EventsDataProvider(this._firebase);

  Future<List<EventData>> list({String query = ''}) async {
    await _firebase.ensureSeedEvents();
    final snapshot = await _firebase.database.ref('events').get();
    final rawEvents = firebaseMap(snapshot.value);
    final entries = rawEvents.entries.toList()
      ..sort((a, b) {
        final aIndex = firebaseMap(a.value)['sort_index'] as num? ?? 0;
        final bIndex = firebaseMap(b.value)['sort_index'] as num? ?? 0;
        return aIndex.compareTo(bIndex);
      });
    final events = entries.map((entry) {
      return EventData.fromMap(
        firebaseMap(entry.value),
        documentId: entry.key,
      );
    }).toList();

    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return events;
    return events.where((event) {
      return event.name.toLowerCase().contains(normalized) ||
          event.location.toLowerCase().contains(normalized) ||
          event.category.toLowerCase().contains(normalized);
    }).toList();
  }

  Future<Set<String>> favoriteIds(String userId) async {
    final snapshot =
        await _firebase.database.ref('users/$userId/favorites').get();
    return firebaseMap(snapshot.value).keys.toSet();
  }

  Future<void> setFavorite(
    String userId,
    String eventId,
    bool favorite,
  ) async {
    final reference =
        _firebase.database.ref('users/$userId/favorites/$eventId');
    if (favorite) {
      await reference.set({
        'event_id': eventId,
        'created_at': DateTime.now().toUtc().toIso8601String(),
      });
    } else {
      await reference.remove();
    }
  }
}
