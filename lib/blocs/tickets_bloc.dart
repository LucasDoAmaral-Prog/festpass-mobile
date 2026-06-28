import 'package:flutter/foundation.dart';

import '../core/models/event.dart';
import '../core/models/ticket.dart';
import '../data/providers/tickets_data_provider.dart';

class TicketsBloc extends ChangeNotifier {
  final TicketsDataProvider _provider;
  TicketsBloc(this._provider);

  List<TicketData> tickets = const [];
  bool loading = false;
  String? error;
  String? _userId;

  Future<void> load(String userId) async {
    _userId = userId;
    loading = true;
    notifyListeners();
    try {
      tickets = await _provider.listForUser(userId);
      error = null;
    } catch (_) {
      error = 'Não foi possível carregar seus ingressos.';
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<TicketData> purchase({
    required EventData event,
    required int lotIndex,
    required int quantity,
    required double total,
    required String paymentMethod,
  }) async {
    final userId = _userId;
    if (userId == null) throw StateError('Usuário não autenticado.');
    final ticket = await _provider.create(
      userId: userId,
      event: event,
      lotIndex: lotIndex,
      quantity: quantity,
      total: total,
      paymentMethod: paymentMethod,
    );
    await load(userId);
    return ticket;
  }

  Future<void> cancel(String ticketId) async {
    final userId = _userId;
    if (userId == null) return;
    await _provider.cancel(ticketId, userId);
    await load(userId);
  }

  Future<void> delete(String ticketId) async {
    final userId = _userId;
    if (userId == null) return;
    await _provider.delete(ticketId, userId);
    await load(userId);
  }

  void clear() {
    _userId = null;
    tickets = const [];
    notifyListeners();
  }
}
