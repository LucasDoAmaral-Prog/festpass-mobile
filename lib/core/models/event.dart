class EventData {
  final String id;
  final String name;
  final String date;
  final String dateDetail;
  final String location;
  final String description;
  final String category;
  final int likes;
  final double price;
  final double taxRate;
  final List<String> lotes;
  final List<double> lotesPrices;
  final int colorIndex;

  const EventData({
    required this.id,
    required this.name,
    required this.date,
    required this.dateDetail,
    required this.location,
    required this.description,
    required this.category,
    required this.likes,
    required this.price,
    required this.taxRate,
    required this.lotes,
    required this.lotesPrices,
    required this.colorIndex,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'date': date,
        'date_detail': dateDetail,
        'location': location,
        'description': description,
        'category': category,
        'likes': likes,
        'price': price,
        'tax_rate': taxRate,
        'lotes': lotes,
        'lotes_prices': lotesPrices,
        'color_index': colorIndex,
      };

  factory EventData.fromMap(Map<String, dynamic> map, {String? documentId}) =>
      EventData(
        id: documentId ?? map['id'] as String,
        name: map['name'] as String,
        date: map['date'] as String,
        dateDetail: map['date_detail'] as String,
        location: map['location'] as String,
        description: map['description'] as String,
        category: map['category'] as String,
        likes: map['likes'] as int,
        price: (map['price'] as num).toDouble(),
        taxRate: (map['tax_rate'] as num).toDouble(),
        lotes: List<String>.from(map['lotes'] as List),
        lotesPrices: (map['lotes_prices'] as List)
            .map((value) => (value as num).toDouble())
            .toList(),
        colorIndex: map['color_index'] as int,
      );
}
