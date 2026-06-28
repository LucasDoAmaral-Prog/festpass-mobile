import 'package:flutter/material.dart';

import '../../../core/models/ticket.dart';
import '../../../shared/app_scope.dart';
import '../../../shared/widgets/event_banner.dart';

class MyTicketsScreen extends StatelessWidget {
  const MyTicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Meus ingressos'),
              Text('Sua área privada',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal))
            ]),
      ),
      body: ListenableBuilder(
        listenable: scope.tickets,
        builder: (context, _) {
          final bloc = scope.tickets;
          if (bloc.loading && bloc.tickets.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (bloc.tickets.isEmpty) {
            return const _EmptyTickets();
          }
          return RefreshIndicator(
            onRefresh: () => bloc.load(scope.auth.user!.id),
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
              itemCount: bloc.tickets.length,
              itemBuilder: (context, index) =>
                  _TicketCard(ticket: bloc.tickets[index]),
            ),
          );
        },
      ),
    );
  }
}

class _TicketCard extends StatelessWidget {
  final TicketData ticket;
  const _TicketCard({required this.ticket});

  @override
  Widget build(BuildContext context) {
    final canceled = ticket.status == 'cancelado';
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFECE4E9))),
      child: Column(
        children: [
          ColorFiltered(
            colorFilter: canceled
                ? const ColorFilter.mode(Colors.grey, BlendMode.saturation)
                : const ColorFilter.mode(Colors.transparent, BlendMode.dst),
            child: EventBanner(colorIndex: ticket.colorIndex, height: 120),
          ),
          Padding(
            padding: const EdgeInsets.all(17),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(
                    child: Text(ticket.eventName,
                        style: Theme.of(context).textTheme.titleMedium)),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                  decoration: BoxDecoration(
                      color: canceled
                          ? const Color(0xFFF2ECEF)
                          : const Color(0xFFE7F8EE),
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(canceled ? 'CANCELADO' : 'ATIVO',
                      style: TextStyle(
                          color: canceled
                              ? const Color(0xFF7B6D75)
                              : const Color(0xFF198754),
                          fontSize: 10,
                          fontWeight: FontWeight.w900)),
                ),
              ]),
              const SizedBox(height: 12),
              _detail(Icons.calendar_today_outlined, ticket.eventDate),
              _detail(Icons.location_on_outlined, ticket.eventLocation),
              _detail(Icons.confirmation_number_outlined,
                  '${ticket.quantity} × ${ticket.lot} · #FP${ticket.displayId}'),
              const Divider(height: 28),
              if (!canceled)
                Row(children: [
                  Expanded(
                      child: ElevatedButton.icon(
                          onPressed: () => _showTicket(context),
                          icon: const Icon(Icons.qr_code_2),
                          label: const Text('Abrir'))),
                  const SizedBox(width: 10),
                  IconButton.outlined(
                      tooltip: 'Cancelar ingresso',
                      onPressed: () => _confirmCancel(context),
                      icon: const Icon(Icons.cancel_outlined)),
                ])
              else
                SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                        onPressed: () => _confirmDelete(context),
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Excluir do histórico'))),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _detail(IconData icon, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 7),
        child: Row(children: [
          Icon(icon, size: 16, color: const Color(0xFF857A82)),
          const SizedBox(width: 8),
          Expanded(
              child: Text(text,
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xFF655D63))))
        ]),
      );

  Future<void> _confirmCancel(BuildContext context) async {
    final confirm = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
                title: const Text('Cancelar ingresso?'),
                content: const Text(
                    'O ingresso ficará inválido. Depois, você poderá excluí-lo do histórico.'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(dialogContext, false),
                      child: const Text('Voltar')),
                  FilledButton(
                      onPressed: () => Navigator.pop(dialogContext, true),
                      child: const Text('Cancelar ingresso'))
                ]));
    if (confirm == true && context.mounted) {
      await AppScope.of(context).tickets.cancel(ticket.id);
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirm = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
                title: const Text('Excluir registro?'),
                content: const Text(
                    'Esta ação remove definitivamente o ingresso cancelado do banco de dados.'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(dialogContext, false),
                      child: const Text('Voltar')),
                  FilledButton(
                      onPressed: () => Navigator.pop(dialogContext, true),
                      child: const Text('Excluir'))
                ]));
    if (confirm == true && context.mounted) {
      await AppScope.of(context).tickets.delete(ticket.id);
    }
  }

  void _showTicket(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 30),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(ticket.eventName,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(ticket.lot, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 22),
            Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border:
                        Border.all(color: const Color(0xFFE2D9DF), width: 8),
                    borderRadius: BorderRadius.circular(14)),
                child: const Icon(Icons.qr_code_2, size: 180)),
            const SizedBox(height: 14),
            Text('#FP${ticket.displayId}',
                style: const TextStyle(
                    fontWeight: FontWeight.w900, letterSpacing: 2)),
            const SizedBox(height: 6),
            const Text('Apresente este código na entrada.',
                style: TextStyle(color: Color(0xFF756A73))),
          ]),
        ),
      ),
    );
  }
}

class _EmptyTickets extends StatelessWidget {
  const _EmptyTickets();
  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.confirmation_number_outlined,
                size: 64, color: Color(0xFFB8ABB4)),
            const SizedBox(height: 16),
            Text('Nenhum ingresso ainda',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            const Text(
                'Quando você concluir uma compra, ela aparecerá aqui e continuará disponível depois de fechar o app.',
                textAlign: TextAlign.center),
          ]),
        ),
      );
}
