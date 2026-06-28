import 'package:flutter/material.dart';

import '../../core/models/ticket.dart';
import '../../shared/widgets/festpass_logo.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final ticket = args['ticket'] as TicketData;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                children: [
                  const FestPassLogoWithSubtitle(),
                  const SizedBox(height: 36),
                  Container(
                    width: 88,
                    height: 88,
                    decoration: const BoxDecoration(
                        color: Color(0xFFE7F8EE), shape: BoxShape.circle),
                    child: const Icon(Icons.check_rounded,
                        size: 48, color: Color(0xFF198754)),
                  ),
                  const SizedBox(height: 22),
                  Text('Ingresso garantido!',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Text(
                      'A compra foi gravada no Firebase Realtime Database e já aparece na sua área privada.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(height: 1.45)),
                  const SizedBox(height: 28),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFEDE5EA))),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(ticket.eventName,
                              style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 14),
                          _line('Pedido', '#FP${ticket.displayId}'),
                          _line(
                              'Ingresso', '${ticket.quantity} × ${ticket.lot}'),
                          _line(
                              'Pagamento',
                              ticket.paymentMethod == 'pix'
                                  ? 'Pix'
                                  : 'Cartão de crédito'),
                          _line('Total',
                              'R\$ ${ticket.total.toStringAsFixed(2).replaceAll('.', ',')}'),
                        ]),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                        context, '/main', (route) => route.isFirst,
                        arguments: {'tabIndex': 1}),
                    icon: const Icon(Icons.confirmation_number_outlined),
                    label: const Text('Ver meus ingressos'),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                        context, '/main', (route) => route.isFirst),
                    child: const Text('Continuar explorando'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _line(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 9),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(label, style: const TextStyle(color: Color(0xFF756A73))),
          Flexible(
              child: Text(value,
                  textAlign: TextAlign.end,
                  style: const TextStyle(fontWeight: FontWeight.w800)))
        ]),
      );
}
