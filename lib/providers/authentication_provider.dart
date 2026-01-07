import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthenticationProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  bool _isLoading = true;

  AuthenticationProvider() {
    _authService.authChanges.listen((user) {
      _user = user;
      _isLoading = false;
      notifyListeners();
    });
  }

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;
  String? get userId => _user?.uid;

  Future<String?> login(String email, String password) async {
    try {
      await _authService.signIn(email, password);
      return null;
    } catch (e) {
      return 'Invalid email or password!';
    }
  }

  Future<String?> register(String email, String password) async {
    try {
      await _authService.signUp(email, password);
      return null;
    } catch (e) {
      print(e);
      return 'Invalid email or password!';
    }
  }

  Future<void> logout() => _authService.signOut();
}
