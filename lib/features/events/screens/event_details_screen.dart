import 'package:flutter/material.dart';
import '../../../core/data/mock_events.dart';
import '../../../shared/widgets/event_banner.dart';

class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({super.key});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  int _quantity = 0;
  int _selectedLote = 0;
  bool _liked = false;
  bool _showFullDescription = false;

  @override
  Widget build(BuildContext context) {
    final event =
        ModalRoute.of(context)?.settings.arguments as EventData? ?? mockEvents[0];

    final selectedPrice = event.lotesPrices[_selectedLote];
    final taxAmount = selectedPrice * event.taxRate;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Custom app bar with event banner
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: Colors.white,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: EventBanner(
                colorIndex: event.colorIndex,
                height: 280,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event name
                  Text(
                    event.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Date
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          color: Colors.grey, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          event.dateDetail,
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Location
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: Colors.grey, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        event.location,
                        style: const TextStyle(
                          color: Color(0xFF1E88E5),
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Action icons row (like, instagram, share)
                  Row(
                    children: [
                      // Like button
                      GestureDetector(
                        onTap: () => setState(() => _liked = !_liked),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: _liked
                                ? const Color(0xFFE91E63).withOpacity(0.1)
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _liked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: _liked
                                    ? const Color(0xFFE91E63)
                                    : Colors.grey,
                                size: 20,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${_liked ? event.likes + 1 : event.likes}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _liked
                                      ? const Color(0xFFE91E63)
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      _buildActionIcon(Icons.camera_alt_outlined),
                      const SizedBox(width: 10),
                      _buildActionIcon(Icons.share_outlined),
                      const SizedBox(width: 10),
                      _buildActionIcon(Icons.file_upload_outlined),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Ingressos section
                  const Text(
                    'Ingressos',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Lote selector
                  ...List.generate(event.lotes.length, (index) {
                    final isSelected = _selectedLote == index;
                    final lotePrice = event.lotesPrices[index];
                    final loteTax = lotePrice * event.taxRate;

                    return GestureDetector(
                      onTap: () => setState(() => _selectedLote = index),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFFCE4EC)
                              : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFFE91E63)
                                : Colors.grey.shade200,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event.lotes[index],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? const Color(0xFFE91E63)
                                        : Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'R\$ ${lotePrice.toStringAsFixed(2).replaceAll('.', ',')}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: isSelected
                                        ? const Color(0xFFE91E63)
                                        : Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '+ taxas a partir de R\$ ${loteTax.toStringAsFixed(2).replaceAll('.', ',')}',
                                  style: TextStyle(
                                      fontSize: 11, color: Colors.grey.shade500),
                                ),
                              ],
                            ),
                            if (isSelected)
                              // Quantity selector
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                ),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (_quantity > 0) {
                                          setState(() => _quantity--);
                                        }
                                      },
                                      child: const Icon(Icons.remove,
                                          size: 18, color: Colors.grey),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14),
                                      child: Text(
                                        '$_quantity',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () =>
                                          setState(() => _quantity++),
                                      child: const Icon(Icons.add,
                                          size: 18,
                                          color: Color(0xFFE91E63)),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 16),

                  // Buy button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _quantity > 0
                          ? () {
                              Navigator.pushNamed(context, '/checkout',
                                  arguments: {
                                    'event': event,
                                    'quantity': _quantity,
                                    'loteIndex': _selectedLote,
                                  });
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE91E63),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey.shade300,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      child: Text(
                        _quantity > 0
                            ? 'Comprar $_quantity ingresso${_quantity > 1 ? 's' : ''}'
                            : 'Selecione a quantidade',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Description
                  Row(
                    children: [
                      const Icon(Icons.description_outlined,
                          size: 18, color: Colors.black87),
                      const SizedBox(width: 8),
                      const Text(
                        'Descrição do Evento',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    event.description,
                    maxLines: _showFullDescription ? null : 4,
                    overflow: _showFullDescription
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.grey,
                      height: 1.5,
                      fontSize: 14,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(
                        () => _showFullDescription = !_showFullDescription),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        _showFullDescription ? 'Ler menos' : 'Ler mais',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Image pages indicator (matching mockup)
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.chevron_left,
                              color: Colors.grey.shade400, size: 20),
                          const SizedBox(width: 8),
                          const Text(
                            '1 / 4',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.chevron_right,
                              color: Colors.black54, size: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.grey, size: 20),
    );
  }
}
