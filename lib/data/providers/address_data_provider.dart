import '../../core/models/address.dart';
import 'firebase_service.dart';

class AddressDataProvider {
  final FirebaseService _firebase;
  AddressDataProvider(this._firebase);

  Future<AddressData?> findForUser(String userId) async {
    final snapshot =
        await _firebase.database.ref('users/$userId/address').get();
    return snapshot.exists
        ? AddressData.fromMap(firebaseMap(snapshot.value))
        : null;
  }

  Future<void> save(String userId, AddressData address) async {
    await _firebase.database.ref('users/$userId/address').set({
      ...address.toMap(),
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    });
  }
}
