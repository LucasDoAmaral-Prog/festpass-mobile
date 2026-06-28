import 'package:flutter/foundation.dart';

import '../core/models/user_profile.dart';
import '../data/providers/auth_data_provider.dart';

class AuthBloc extends ChangeNotifier {
  final AuthDataProvider _provider;
  AuthBloc(this._provider);

  UserProfile? user;
  bool busy = false;
  String? error;

  Future<void> restoreSession() async {
    try {
      user = await _provider.currentUser();
    } catch (exception) {
      error = exception.toString();
    }
  }

  Future<bool> login(String email, String password) async {
    return _run(() => _provider.login(email, password));
  }

  Future<bool> register(String name, String email, String password) async {
    return _run(() => _provider.register(
          name: name,
          email: email,
          password: password,
        ));
  }

  Future<bool> updateProfile(String name, String phone) async {
    final current = user;
    if (current == null) return false;
    return _run(() => _provider.updateProfile(
          current.id,
          name: name,
          phone: phone,
        ));
  }

  Future<bool> _run(Future<UserProfile> Function() operation) async {
    busy = true;
    error = null;
    notifyListeners();
    try {
      user = await operation();
      return true;
    } catch (exception) {
      error = exception.toString();
      return false;
    } finally {
      busy = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _provider.logout();
    user = null;
    error = null;
    notifyListeners();
  }
}
