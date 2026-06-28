import 'package:firebase_database/firebase_database.dart';

import '../../core/models/event.dart';
import '../../core/models/ticket.dart';
import 'firebase_service.dart';

class TicketsDataProvider {
  final FirebaseService _firebase;
  TicketsDataProvider(this._firebase);

  DatabaseReference _tickets(String userId) =>
      _firebase.database.ref('users/$userId/tickets');

  Future<List<TicketData>> listForUser(String userId) async {
    final snapshot = await _tickets(userId).get();
    final tickets = firebaseMap(snapshot.value).entries.map((entry) {
      return TicketData.fromMap(entry.key, firebaseMap(entry.value));
    }).toList()
      ..sort((a, b) => b.purchasedAt.compareTo(a.purchasedAt));
    return tickets;
  }

  Future<TicketData> create({
    required String userId,
    required EventData event,
    required int lotIndex,
    required int quantity,
    required double total,
    required String paymentMethod,
  }) async {
    final reference = _tickets(userId).push();
    final data = <String, dynamic>{
      'user_id': userId,
      'event_id': event.id,
      'event_name': event.name,
      'event_date': event.dateDetail,
      'event_location': event.location,
      'color_index': event.colorIndex,
      'lot': event.lotes[lotIndex],
      'quantity': quantity,
      'total': total,
      'payment_method': paymentMethod,
      'status': 'ativo',
      'purchased_at': DateTime.now().toUtc().toIso8601String(),
    };
    await reference.set(data);
    return TicketData.fromMap(reference.key!, data);
  }

  Future<void> cancel(String ticketId, String userId) async {
    await _tickets(userId).child(ticketId).update({'status': 'cancelado'});
  }

  Future<void> delete(String ticketId, String userId) async {
    final reference = _tickets(userId).child(ticketId);
    final snapshot = await reference.get();
    if (firebaseMap(snapshot.value)['status'] != 'cancelado') {
      throw StateError('Somente ingressos cancelados podem ser excluídos.');
    }
    await reference.remove();
  }
}
