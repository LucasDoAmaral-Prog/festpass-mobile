import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../core/models/user_profile.dart';
import 'firebase_service.dart';

class AuthDataProvider {
  final FirebaseService _firebase;

  AuthDataProvider(this._firebase);

  Future<UserProfile?> currentUser() async {
    final user = _firebase.auth.currentUser;
    return user == null ? null : _profileFor(user);
  }

  Future<UserProfile> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebase.auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user!;
      final data = <String, dynamic>{
        'name': name.trim(),
        'email': user.email ?? email.trim().toLowerCase(),
        'phone': '',
        'created_at': DateTime.now().toUtc().toIso8601String(),
      };
      try {
        await _profile(user.uid).set(data);
        await user.updateDisplayName(name.trim());
      } on FirebaseException {
        await _deleteCurrentUser();
        throw const AuthException(
          'Não foi possível salvar o perfil no Firebase.',
        );
      }
      return UserProfile.fromMap(user.uid, data);
    } on FirebaseAuthException catch (error) {
      throw AuthException(_messageFor(error));
    }
  }

  Future<UserProfile> login(String email, String password) async {
    try {
      final credential = await _firebase.auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return _profileFor(credential.user!);
    } on FirebaseAuthException catch (error) {
      throw AuthException(_messageFor(error));
    }
  }

  Future<UserProfile> updateProfile(
    String userId, {
    required String name,
    required String phone,
  }) async {
    final user = _firebase.auth.currentUser;
    if (user == null || user.uid != userId) {
      throw const AuthException('Sua sessão expirou. Entre novamente.');
    }
    await _profile(userId).update({
      'name': name.trim(),
      'phone': phone.trim(),
      'email': user.email ?? '',
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    });
    await user.updateDisplayName(name.trim());
    return _profileFor(user);
  }

  Future<void> logout() => _firebase.auth.signOut();

  DatabaseReference _profile(String userId) =>
      _firebase.database.ref('users/$userId/profile');

  Future<UserProfile> _profileFor(User user) async {
    final reference = _profile(user.uid);
    final snapshot = await reference.get();
    if (snapshot.exists) {
      return UserProfile.fromMap(user.uid, firebaseMap(snapshot.value));
    }

    final data = <String, dynamic>{
      'name': user.displayName ?? user.email?.split('@').first ?? 'Usuário',
      'email': user.email ?? '',
      'phone': '',
      'created_at': DateTime.now().toUtc().toIso8601String(),
    };
    await reference.set(data);
    return UserProfile.fromMap(user.uid, data);
  }

  Future<void> _deleteCurrentUser() async {
    try {
      await _firebase.auth.currentUser?.delete();
    } catch (_) {
      await _firebase.auth.signOut();
    }
  }

  String _messageFor(FirebaseAuthException error) {
    switch (error.code) {
      case 'email-already-in-use':
        return 'Este e-mail já possui uma conta.';
      case 'invalid-email':
        return 'Informe um e-mail válido.';
      case 'weak-password':
        return 'A senha precisa ter pelo menos 6 caracteres.';
      case 'invalid-credential':
      case 'user-not-found':
      case 'wrong-password':
        return 'E-mail ou senha incorretos.';
      case 'network-request-failed':
        return 'Sem conexão com o Firebase. Verifique sua internet.';
      case 'too-many-requests':
        return 'Muitas tentativas. Aguarde um pouco e tente novamente.';
      default:
        return error.message ?? 'Não foi possível autenticar no Firebase.';
    }
  }
}

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);
  @override
  String toString() => message;
}
