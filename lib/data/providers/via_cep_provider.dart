import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/models/address.dart';

class ViaCepProvider {
  final http.Client _client;
  ViaCepProvider({http.Client? client}) : _client = client ?? http.Client();

  Future<AddressData> lookup(String value) async {
    final cep = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (cep.length != 8) {
      throw const ViaCepException('Informe um CEP com 8 números.');
    }
    final response = await _client
        .get(Uri.parse('https://viacep.com.br/ws/$cep/json/'))
        .timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) {
      throw const ViaCepException('O serviço de CEP não respondeu.');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (json['erro'] == true) {
      throw const ViaCepException('CEP não encontrado.');
    }
    return AddressData.fromViaCep(json);
  }
}

class ViaCepException implements Exception {
  final String message;
  const ViaCepException(this.message);
  @override
  String toString() => message;
}
