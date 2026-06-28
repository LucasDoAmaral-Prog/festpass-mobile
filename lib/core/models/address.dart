class AddressData {
  final String cep;
  final String street;
  final String number;
  final String complement;
  final String neighborhood;
  final String city;
  final String state;

  const AddressData({
    required this.cep,
    required this.street,
    required this.number,
    required this.complement,
    required this.neighborhood,
    required this.city,
    required this.state,
  });

  factory AddressData.fromViaCep(Map<String, dynamic> json) => AddressData(
        cep: (json['cep'] as String? ?? '').replaceAll(RegExp(r'[^0-9]'), ''),
        street: json['logradouro'] as String? ?? '',
        number: '',
        complement: json['complemento'] as String? ?? '',
        neighborhood: json['bairro'] as String? ?? '',
        city: json['localidade'] as String? ?? '',
        state: json['uf'] as String? ?? '',
      );

  factory AddressData.fromMap(Map<String, dynamic> map) => AddressData(
        cep: map['cep'] as String? ?? '',
        street: map['street'] as String? ?? '',
        number: map['number'] as String? ?? '',
        complement: map['complement'] as String? ?? '',
        neighborhood: map['neighborhood'] as String? ?? '',
        city: map['city'] as String? ?? '',
        state: map['state'] as String? ?? '',
      );

  Map<String, dynamic> toMap() => {
        'cep': cep,
        'street': street,
        'number': number,
        'complement': complement,
        'neighborhood': neighborhood,
        'city': city,
        'state': state,
      };
}
