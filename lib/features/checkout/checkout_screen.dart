import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  
  String _paymentMethod = 'pix';
  bool _saveAddress = false;
  
  // Controllers
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

  void _finishPurchase() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Row(
              children: [
                Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 10),
                const Text('Compra Confirmada!', style: TextStyle(fontSize: 18)),
              ],
            ),
            content: const Text('Seu ingresso foi gerado com sucesso e já está disponível na sua carteira.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); 
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Redirecionando para seus ingressos...'),
                      backgroundColor: Colors.green,
                    )
                  );
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: Text('Ir para Ingressos', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
              ),
            ],
          );
        }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Detalhes da compra', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Métodos de pagamento', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const Text('Com pix é mais rápido!', style: TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    RadioListTile<String>(
                      title: const Row(
                        children: [
                          Icon(Icons.pix, color: Colors.grey, size: 20),
                          SizedBox(width: 8),
                          Text('Pix', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      value: 'pix',
                      groupValue: _paymentMethod,
                      activeColor: Theme.of(context).colorScheme.primary,
                      onChanged: (value) => setState(() => _paymentMethod = value!),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                    const Divider(height: 1),
                    RadioListTile<String>(
                      title: const Row(
                        children: [
                          Icon(Icons.credit_card, color: Colors.grey, size: 20),
                          SizedBox(width: 8),
                          Text('Cartão de Crédito', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      value: 'credit_card',
                      groupValue: _paymentMethod,
                      activeColor: Theme.of(context).colorScheme.primary,
                      onChanged: (value) => setState(() => _paymentMethod = value!),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              const Text('Endereço do comprador', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _cepController,
                decoration: const InputDecoration(hintText: 'CEP'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(hintText: 'LOGRADOURO (RUA)'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: _numberController,
                      decoration: const InputDecoration(hintText: 'Nº'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _complementController,
                      decoration: const InputDecoration(hintText: 'Complemento (Opcional)'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _neighborhoodController,
                      decoration: const InputDecoration(hintText: 'Bairro'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _cityController,
                      decoration: const InputDecoration(hintText: 'Cidade'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _stateController,
                decoration: const InputDecoration(hintText: 'Estado'),
              ),
              
              const SizedBox(height: 8),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Salvar esse endereço na conta', style: TextStyle(fontSize: 14)),
                value: _saveAddress,
                activeColor: Theme.of(context).colorScheme.primary,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (value) => setState(() => _saveAddress = value!),
              ),
              const SizedBox(height: 32),
              
              const Text('Detalhes da compra', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Subtotal', style: TextStyle(color: Colors.black87)),
                  Text('R\$ 75,00', style: TextStyle(color: Colors.black87)),
                ],
              ),
              const SizedBox(height: 8),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Valor da taxa', style: TextStyle(color: Colors.black87)),
                  Text('R\$ 7,50', style: TextStyle(color: Colors.black87)),
                ],
              ),
              const SizedBox(height: 8),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text('R\$ 82,50', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _finishPurchase,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // Dark button per mockup "Gerar Pix"
                  ),
                  child: Text(
                    _paymentMethod == 'pix' ? 'Gerar Pix' : 'Pagar',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
}
