import 'package:flutter/material.dart';
import '../../core/data/mock_events.dart';
import '../../shared/widgets/event_banner.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  String _paymentMethod = 'pix';
  bool _saveAddress = false;

  final _cepController = TextEditingController();
  final _addressController = TextEditingController();
  final _numberController = TextEditingController();
  final _complementController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();

  @override
  void dispose() {
    _cepController.dispose();
    _addressController.dispose();
    _numberController.dispose();
    _complementController.dispose();
    _neighborhoodController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final event = args?['event'] as EventData? ?? mockEvents[0];
    final quantity = args?['quantity'] as int? ?? 1;
    final loteIndex = args?['loteIndex'] as int? ?? 0;

    final price = event.lotesPrices[loteIndex];
    final subtotal = price * quantity;
    final tax = subtotal * event.taxRate;
    final total = subtotal + tax;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Detalhes da compra',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.grey.shade200,
            height: 1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tab indicator
              Row(
                children: [
                  Text(
                    'Pagamento',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Payment methods
              const Text(
                'Métodos de pagamento',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 4),
              const Text(
                'Com pix é mais rápido!',
                style: TextStyle(color: Color(0xFF4CAF50), fontSize: 12),
              ),
              const SizedBox(height: 12),

              // Pix option
              _buildPaymentOption(
                icon: Icons.pix,
                label: 'Pix',
                value: 'pix',
              ),
              const SizedBox(height: 8),
              // Credit card option
              _buildPaymentOption(
                icon: Icons.credit_card,
                label: 'Cartão de Crédito',
                value: 'credit_card',
              ),
              const SizedBox(height: 28),

              // Address section
              const Text(
                'Endereço do comprador',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 16),

              _buildTextField(_cepController, 'CEP'),
              const SizedBox(height: 10),
              _buildTextField(_addressController, 'LOGRADOURO (RUA)'),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child:
                          _buildTextField(_numberController, 'Nº')),
                  const SizedBox(width: 10),
                  Expanded(
                      flex: 2,
                      child: _buildTextField(
                          _complementController, 'Complemento (Opcional)')),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                      child: _buildTextField(
                          _stateController, 'Estado')),
                  const SizedBox(width: 10),
                  Expanded(
                      child: _buildTextField(
                          _cityController, 'Cidade')),
                ],
              ),
              const SizedBox(height: 10),
              _buildTextField(_neighborhoodController, 'Bairro'),

              const SizedBox(height: 8),
              Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: _saveAddress,
                      activeColor: const Color(0xFFE91E63),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      onChanged: (value) =>
                          setState(() => _saveAddress = value!),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Salvar esse endereço na conta',
                    style: TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Purchase details
              const Text(
                'Detalhes da compra',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 16),
              _buildPriceRow('Subtotal',
                  'R\$ ${subtotal.toStringAsFixed(2).replaceAll('.', ',')}'),
              const SizedBox(height: 8),
              _buildPriceRow('Valor da taxa',
                  'R\$ ${tax.toStringAsFixed(2).replaceAll('.', ',')}'),
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              _buildPriceRow(
                'Total',
                'R\$ ${total.toStringAsFixed(2).replaceAll('.', ',')}',
                isBold: true,
              ),
              const SizedBox(height: 28),

              // Pay button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/confirmation',
                      arguments: {
                        'event': event,
                        'quantity': quantity,
                        'loteIndex': loteIndex,
                        'total': total,
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Text(
                    _paymentMethod == 'pix' ? 'Gerar Pix' : 'Pagar',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required IconData icon,
    required String label,
    required String value,
  }) {
    final isSelected = _paymentMethod == value;
    return GestureDetector(
      onTap: () => setState(() => _paymentMethod = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFCE4EC) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFE91E63)
                : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? const Color(0xFFE91E63) : Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 12),
            Icon(icon, color: Colors.grey.shade600, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isSelected ? const Color(0xFFE91E63) : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: Color(0xFFE91E63), width: 2),
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value,
      {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.black87,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: isBold ? 16 : 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.black87,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: isBold ? 16 : 14,
          ),
        ),
      ],
    );
  }
}
