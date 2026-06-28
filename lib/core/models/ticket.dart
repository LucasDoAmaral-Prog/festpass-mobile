class TicketData {
  final String id;
  final String userId;
  final String eventId;
  final String eventName;
  final String eventDate;
  final String eventLocation;
  final int colorIndex;
  final String lot;
  final int quantity;
  final double total;
  final String paymentMethod;
  final String status;
  final String purchasedAt;

  const TicketData({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.eventName,
    required this.eventDate,
    required this.eventLocation,
    required this.colorIndex,
    required this.lot,
    required this.quantity,
    required this.total,
    required this.paymentMethod,
    required this.status,
    required this.purchasedAt,
  });

  factory TicketData.fromMap(String id, Map<String, dynamic> map) => TicketData(
        id: id,
        userId: map['user_id'] as String,
        eventId: map['event_id'] as String,
        eventName: map['event_name'] as String,
        eventDate: map['event_date'] as String,
        eventLocation: map['event_location'] as String,
        colorIndex: map['color_index'] as int,
        lot: map['lot'] as String,
        quantity: map['quantity'] as int,
        total: (map['total'] as num).toDouble(),
        paymentMethod: map['payment_method'] as String,
        status: map['status'] as String,
        purchasedAt: map['purchased_at'] as String,
      );

  String get displayId =>
      id.substring(0, id.length < 8 ? id.length : 8).toUpperCase();
}
