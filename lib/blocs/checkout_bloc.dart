import 'package:flutter/foundation.dart';

import '../core/models/address.dart';
import '../data/providers/address_data_provider.dart';
import '../data/providers/via_cep_provider.dart';

class CheckoutBloc extends ChangeNotifier {
  final ViaCepProvider _viaCepProvider;
  final AddressDataProvider _addressProvider;
  CheckoutBloc(this._viaCepProvider, this._addressProvider);

  bool loadingCep = false;
  String? error;

  Future<AddressData?> savedAddress(String userId) =>
      _addressProvider.findForUser(userId);

  Future<AddressData?> lookupCep(String cep) async {
    loadingCep = true;
    error = null;
    notifyListeners();
    try {
      return await _viaCepProvider.lookup(cep);
    } catch (exception) {
      error = exception.toString();
      return null;
    } finally {
      loadingCep = false;
      notifyListeners();
    }
  }

  Future<void> saveAddress(String userId, AddressData address) =>
      _addressProvider.save(userId, address);
}
