import 'package:flutter/material.dart';

import '../../core/models/address.dart';
import '../../core/models/event.dart';
import '../../shared/app_scope.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cep = TextEditingController();
  final _street = TextEditingController();
  final _number = TextEditingController();
  final _complement = TextEditingController();
  final _neighborhood = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  String _payment = 'pix';
  bool _saveAddress = true;
  bool _loaded = false;
  bool _finishing = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _loaded = true;
      _loadSavedAddress();
    }
  }

  Future<void> _loadSavedAddress() async {
    final scope = AppScope.of(context);
    final address = await scope.checkout.savedAddress(scope.auth.user!.id);
    if (address != null && mounted) _fill(address);
  }

  void _fill(AddressData address) {
    _cep.text = address.cep;
    _street.text = address.street;
    _number.text = address.number;
    _complement.text = address.complement;
    _neighborhood.text = address.neighborhood;
    _city.text = address.city;
    _state.text = address.state;
  }

  AddressData get _address => AddressData(
        cep: _cep.text.replaceAll(RegExp(r'[^0-9]'), ''),
        street: _street.text.trim(),
        number: _number.text.trim(),
        complement: _complement.text.trim(),
        neighborhood: _neighborhood.text.trim(),
        city: _city.text.trim(),
        state: _state.text.trim().toUpperCase(),
      );

  Future<void> _lookupCep() async {
    final checkout = AppScope.of(context).checkout;
    final address = await checkout.lookupCep(_cep.text);
    if (!mounted) return;
    if (address != null) {
      _fill(address);
      FocusScope.of(context).nextFocus();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Endereço recebido da API ViaCEP.')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(checkout.error ?? 'CEP não encontrado.')));
    }
  }

  Future<void> _finish(
      EventData event, int quantity, int lotIndex, double total) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _finishing = true);
    final scope = AppScope.of(context);
    try {
      if (_saveAddress) {
        await scope.checkout.saveAddress(scope.auth.user!.id, _address);
      }
      final ticket = await scope.tickets.purchase(
        event: event,
        lotIndex: lotIndex,
        quantity: quantity,
        total: total,
        paymentMethod: _payment,
      );
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/confirmation',
          arguments: {'ticket': ticket});
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Não foi possível concluir a compra.')));
      }
    } finally {
      if (mounted) setState(() => _finishing = false);
    }
  }

  @override
  void dispose() {
    for (final controller in [
      _cep,
      _street,
      _number,
      _complement,
      _neighborhood,
      _city,
      _state
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final event = args['event'] as EventData;
    final quantity = args['quantity'] as int;
    final lotIndex = args['loteIndex'] as int;
    final subtotal = event.lotesPrices[lotIndex] * quantity;
    final fee = subtotal * event.taxRate;
    final total = subtotal + fee;
    final checkout = AppScope.of(context).checkout;

    return Scaffold(
      appBar: AppBar(title: const Text('Finalizar compra')),
      body: ListenableBuilder(
        listenable: checkout,
        builder: (context, _) => Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
            children: [
              _OrderSummary(
                  event: event, quantity: quantity, lot: event.lotes[lotIndex]),
              const SizedBox(height: 28),
              Text('Pagamento', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                      value: 'pix', icon: Icon(Icons.pix), label: Text('Pix')),
                  ButtonSegment(
                      value: 'credito',
                      icon: Icon(Icons.credit_card),
                      label: Text('Crédito')),
                ],
                selected: {_payment},
                onSelectionChanged: (value) =>
                    setState(() => _payment = value.first),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                      child: Text('Endereço do comprador',
                          style: Theme.of(context).textTheme.titleLarge)),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                    decoration: BoxDecoration(
                        color: const Color(0xFFEAF6FF),
                        borderRadius: BorderRadius.circular(20)),
                    child: const Row(children: [
                      Icon(Icons.cloud_done_outlined,
                          size: 15, color: Color(0xFF147DB3)),
                      SizedBox(width: 5),
                      Text('ViaCEP · internet',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF147DB3)))
                    ]),
                  ),
                ],
              ),
              const SizedBox(height: 7),
              Text(
                  'Digite o CEP e toque na lupa para preencher os dados pela API.',
                  style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 14),
              TextFormField(
                controller: _cep,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.search,
                onFieldSubmitted: (_) => _lookupCep(),
                decoration: InputDecoration(
                  labelText: 'CEP',
                  suffixIcon: checkout.loadingCep
                      ? const Padding(
                          padding: EdgeInsets.all(14),
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : IconButton(
                          onPressed: _lookupCep,
                          tooltip: 'Buscar na internet',
                          icon: const Icon(Icons.search)),
                ),
                validator: (value) =>
                    value!.replaceAll(RegExp(r'[^0-9]'), '').length != 8
                        ? 'CEP inválido.'
                        : null,
              ),
              const SizedBox(height: 11),
              _field(_street, 'Rua'),
              const SizedBox(height: 11),
              Row(children: [
                Expanded(child: _field(_number, 'Número')),
                const SizedBox(width: 11),
                Expanded(
                    flex: 2,
                    child: _field(_complement, 'Complemento', optional: true))
              ]),
              const SizedBox(height: 11),
              _field(_neighborhood, 'Bairro'),
              const SizedBox(height: 11),
              Row(children: [
                Expanded(flex: 3, child: _field(_city, 'Cidade')),
                const SizedBox(width: 11),
                Expanded(child: _field(_state, 'UF'))
              ]),
              CheckboxListTile(
                value: _saveAddress,
                onChanged: (value) => setState(() => _saveAddress = value!),
                contentPadding: EdgeInsets.zero,
                title: const Text('Salvar ou atualizar este endereço'),
                subtitle:
                    const Text('Ele fica disponível somente na sua conta.'),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: 22),
              Text('Resumo', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              _price('Ingressos', subtotal),
              _price('Taxa de serviço', fee),
              const Divider(height: 28),
              _price('Total', total, bold: true),
              const SizedBox(height: 22),
              ElevatedButton(
                onPressed: _finishing
                    ? null
                    : () => _finish(event, quantity, lotIndex, total),
                child: _finishing
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : Text(_payment == 'pix'
                        ? 'Confirmar com Pix'
                        : 'Confirmar pagamento'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController controller, String label,
          {bool optional = false}) =>
      TextFormField(
        controller: controller,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(labelText: label),
        validator: optional
            ? null
            : (value) => value!.trim().isEmpty ? 'Obrigatório.' : null,
      );

  Widget _price(String label, double value, {bool bold = false}) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight: bold ? FontWeight.w900 : FontWeight.normal)),
          Text('R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}',
              style: TextStyle(
                  fontWeight: bold ? FontWeight.w900 : FontWeight.w600,
                  fontSize: bold ? 18 : 14))
        ],
      );
}

class _OrderSummary extends StatelessWidget {
  final EventData event;
  final int quantity;
  final String lot;
  const _OrderSummary(
      {required this.event, required this.quantity, required this.lot});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: const Color(0xFF211A27),
            borderRadius: BorderRadius.circular(18)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(event.name,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Colors.white)),
          const SizedBox(height: 8),
          Text('$quantity × $lot',
              style: const TextStyle(color: Color(0xFFD7C9D4))),
          const SizedBox(height: 4),
          Text(event.date, style: const TextStyle(color: Color(0xFFD7C9D4)))
        ]),
      );
}
