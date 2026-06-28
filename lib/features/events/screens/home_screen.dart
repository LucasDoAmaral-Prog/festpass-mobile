import 'package:flutter/material.dart';

import '../../../blocs/events_bloc.dart';
import '../../../core/models/event.dart';
import '../../../shared/app_scope.dart';
import '../../../shared/widgets/event_banner.dart';
import '../../../shared/widgets/festpass_logo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _search = TextEditingController();
  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scope = AppScope.of(context);
    final firstName = scope.auth.user!.name.split(' ').first;
    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: scope.events,
          builder: (context, _) => RefreshIndicator(
            onRefresh: () =>
                scope.events.load(scope.auth.user!.id, query: _search.text),
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FestPassLogo(),
                            Icon(Icons.notifications_none_rounded)
                          ],
                        ),
                        const SizedBox(height: 26),
                        Text('Olá, $firstName 👋',
                            style: Theme.of(context).textTheme.bodyLarge),
                        const SizedBox(height: 4),
                        Text('Qual vai ser a próxima?',
                            style: Theme.of(context).textTheme.headlineMedium),
                        const SizedBox(height: 18),
                        TextField(
                          controller: _search,
                          textInputAction: TextInputAction.search,
                          onSubmitted: scope.events.search,
                          decoration: InputDecoration(
                            hintText: 'Evento, cidade ou categoria',
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: IconButton(
                              tooltip: 'Limpar busca',
                              onPressed: () {
                                _search.clear();
                                scope.events.search('');
                              },
                              icon: const Icon(Icons.close),
                            ),
                          ),
                        ),
                        const SizedBox(height: 26),
                      ],
                    ),
                  ),
                ),
                if (scope.events.loading && scope.events.events.isEmpty)
                  const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()))
                else if (scope.events.error != null &&
                    scope.events.events.isEmpty)
                  SliverFillRemaining(
                    child: _Message(
                        icon: Icons.cloud_off_outlined,
                        text: scope.events.error!),
                  )
                else if (scope.events.events.isEmpty)
                  const SliverFillRemaining(
                    child: _Message(
                        icon: Icons.search_off_rounded,
                        text: 'Nenhum evento combina com essa busca.'),
                  )
                else ...[
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverToBoxAdapter(
                        child: _FeaturedCard(
                            event: scope.events.events.first,
                            bloc: scope.events)),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 30, 20, 12),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Agenda completa',
                              style: Theme.of(context).textTheme.titleLarge),
                          Text('${scope.events.events.length} eventos',
                              style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _EventRow(
                            event: scope.events.events[index],
                            bloc: scope.events),
                        childCount: scope.events.events.length,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  final EventData event;
  final EventsBloc bloc;
  const _FeaturedCard({required this.event, required this.bloc});

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () =>
            Navigator.pushNamed(context, '/event_details', arguments: event),
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x12000000),
                    blurRadius: 22,
                    offset: Offset(0, 8))
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  EventBanner(
                      colorIndex: event.colorIndex,
                      height: 210,
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(24))),
                  Positioned(
                      top: 14, left: 14, child: _Tag(text: event.category)),
                  Positioned(
                      top: 10,
                      right: 10,
                      child: _FavoriteButton(event: event, bloc: bloc)),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('DESTAQUE DA SEMANA',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.1)),
                    const SizedBox(height: 7),
                    Text(event.name,
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 10),
                    _Meta(
                        icon: Icons.calendar_today_outlined, text: event.date),
                    const SizedBox(height: 6),
                    _Meta(
                        icon: Icons.location_on_outlined, text: event.location),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}

class _EventRow extends StatelessWidget {
  final EventData event;
  final EventsBloc bloc;
  const _EventRow({required this.event, required this.bloc});
  @override
  Widget build(BuildContext context) => Card(
        elevation: 0,
        color: Colors.white,
        margin: const EdgeInsets.only(bottom: 12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () =>
              Navigator.pushNamed(context, '/event_details', arguments: event),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                SizedBox(
                    width: 96,
                    height: 96,
                    child: EventBanner(
                        colorIndex: event.colorIndex,
                        height: 96,
                        borderRadius: BorderRadius.circular(14))),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(event.date,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 11,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Text(event.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 7),
                      Text(event.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: 6),
                      Text(
                          'A partir de R\$ ${event.price.toStringAsFixed(2).replaceAll('.', ',')}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 12)),
                    ],
                  ),
                ),
                _FavoriteButton(event: event, bloc: bloc, dark: true),
              ],
            ),
          ),
        ),
      );
}

class _FavoriteButton extends StatelessWidget {
  final EventData event;
  final EventsBloc bloc;
  final bool dark;
  const _FavoriteButton(
      {required this.event, required this.bloc, this.dark = false});
  @override
  Widget build(BuildContext context) {
    final selected = bloc.favoriteIds.contains(event.id);
    return IconButton.filled(
      tooltip: selected ? 'Remover dos favoritos' : 'Salvar nos favoritos',
      onPressed: () => bloc.toggleFavorite(event.id),
      style: IconButton.styleFrom(
          backgroundColor: dark
              ? const Color(0xFFF7F2F5)
              : Colors.white.withValues(alpha: .92)),
      icon: Icon(selected ? Icons.favorite : Icons.favorite_border,
          color: selected ? const Color(0xFFE51F68) : const Color(0xFF514A57)),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  const _Tag({required this.text});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
        decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: .72),
            borderRadius: BorderRadius.circular(30)),
        child: Text(text,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w800)),
      );
}

class _Meta extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Meta({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) => Row(children: [
        Icon(icon, size: 16, color: const Color(0xFF827887)),
        const SizedBox(width: 7),
        Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodySmall))
      ]);
}

class _Message extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Message({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) => Center(
      child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 54, color: const Color(0xFFB7AAB4)),
            const SizedBox(height: 14),
            Text(text, textAlign: TextAlign.center)
          ])));
}
