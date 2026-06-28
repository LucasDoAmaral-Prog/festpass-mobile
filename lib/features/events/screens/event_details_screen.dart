import 'package:flutter/material.dart';

import '../../../core/models/event.dart';
import '../../../shared/app_scope.dart';
import '../../../shared/widgets/event_banner.dart';

class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({super.key});
  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  int _lotIndex = 0;
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final event = ModalRoute.of(context)!.settings.arguments as EventData;
    final eventsBloc = AppScope.of(context).events;
    final amount = event.lotesPrices[_lotIndex] * _quantity;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: const Color(0xFF17131F),
            foregroundColor: Colors.white,
            actions: [
              ListenableBuilder(
                listenable: eventsBloc,
                builder: (_, __) => IconButton.filledTonal(
                  onPressed: () => eventsBloc.toggleFavorite(event.id),
                  icon: Icon(eventsBloc.favoriteIds.contains(event.id)
                      ? Icons.favorite
                      : Icons.favorite_border),
                ),
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background:
                  EventBanner(colorIndex: event.colorIndex, height: 320),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(22, 24, 22, 130),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(event.category.toUpperCase(),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.1,
                        fontSize: 11)),
                const SizedBox(height: 7),
                Text(event.name,
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 20),
                _InfoTile(
                    icon: Icons.calendar_month_outlined,
                    title: 'Quando',
                    value: event.dateDetail),
                _InfoTile(
                    icon: Icons.location_on_outlined,
                    title: 'Onde',
                    value: event.location),
                _InfoTile(
                    icon: Icons.favorite_outline,
                    title: 'Comunidade',
                    value: '${event.likes} pessoas salvaram este evento'),
                const SizedBox(height: 18),
                Text('Sobre o evento',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 10),
                Text(event.description,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(height: 1.55)),
                const SizedBox(height: 28),
                Text('Escolha seu ingresso',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                RadioGroup<int>(
                  groupValue: _lotIndex,
                  onChanged: (value) => setState(() => _lotIndex = value!),
                  child: Column(
                    children: List.generate(
                        event.lotes.length,
                        (index) => RadioListTile<int>(
                              value: index,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  side: BorderSide(
                                      color: index == _lotIndex
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : const Color(0xFFE9E1E6))),
                              title: Text(event.lotes[index],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700)),
                              secondary: Text(
                                  'R\$ ${event.lotesPrices[index].toStringAsFixed(2).replaceAll('.', ',')}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w900)),
                            )),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Quantidade',
                        style: TextStyle(fontWeight: FontWeight.w800)),
                    Row(children: [
                      IconButton.outlined(
                          onPressed: _quantity > 1
                              ? () => setState(() => _quantity--)
                              : null,
                          icon: const Icon(Icons.remove)),
                      SizedBox(
                          width: 40,
                          child: Text('$_quantity',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium)),
                      IconButton.outlined(
                          onPressed: _quantity < 5
                              ? () => setState(() => _quantity++)
                              : null,
                          icon: const Icon(Icons.add)),
                    ]),
                  ],
                ),
              ]),
            ),
          ),
        ],
      ),
      bottomSheet: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
          decoration: const BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                color: Color(0x18000000), blurRadius: 20, offset: Offset(0, -4))
          ]),
          child: Row(children: [
            Expanded(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  const Text('Subtotal', style: TextStyle(fontSize: 11)),
                  Text('R\$ ${amount.toStringAsFixed(2).replaceAll('.', ',')}',
                      style: Theme.of(context).textTheme.titleLarge)
                ])),
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/checkout',
                    arguments: {
                      'event': event,
                      'quantity': _quantity,
                      'loteIndex': _lotIndex
                    }),
                child: const Text('Continuar'),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  const _InfoTile(
      {required this.icon, required this.title, required this.value});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 13),
        child: Row(children: [
          Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                  color: const Color(0xFFF7EEF3),
                  borderRadius: BorderRadius.circular(13)),
              child: Icon(icon, color: Theme.of(context).colorScheme.primary)),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(title, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontWeight: FontWeight.w700))
              ])),
        ]),
      );
}
