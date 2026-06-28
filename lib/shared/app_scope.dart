import 'package:flutter/widgets.dart';

import '../blocs/auth_bloc.dart';
import '../blocs/checkout_bloc.dart';
import '../blocs/events_bloc.dart';
import '../blocs/tickets_bloc.dart';

class AppScope extends InheritedWidget {
  final AuthBloc auth;
  final EventsBloc events;
  final TicketsBloc tickets;
  final CheckoutBloc checkout;

  const AppScope({
    super.key,
    required this.auth,
    required this.events,
    required this.tickets,
    required this.checkout,
    required super.child,
  });

  static AppScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope não encontrado na árvore.');
    return scope!;
  }

  @override
  bool updateShouldNotify(AppScope oldWidget) => false;
}
