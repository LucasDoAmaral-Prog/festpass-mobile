class UserProfile {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String createdAt;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.createdAt,
  });

  factory UserProfile.fromMap(String id, Map<String, dynamic> map) =>
      UserProfile(
        id: id,
        name: map['name'] as String,
        email: map['email'] as String,
        phone: (map['phone'] as String?) ?? '',
        createdAt: map['created_at'] as String,
      );

  UserProfile copyWith({String? name, String? phone}) => UserProfile(
        id: id,
        name: name ?? this.name,
        email: email,
        phone: phone ?? this.phone,
        createdAt: createdAt,
      );

  String get displayId =>
      id.substring(0, id.length < 8 ? id.length : 8).toUpperCase();
}
