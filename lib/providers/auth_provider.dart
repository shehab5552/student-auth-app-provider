import 'package:flutter/foundation.dart';

import '../models/login_request.dart';
import '../models/password_reset_request.dart';
import '../models/register_request.dart';
import '../models/reset_password_request.dart';
import '../models/user_model.dart';
import '../repositories/auth_exception.dart';
import '../repositories/auth_repository.dart';

/// Coordinates authentication use cases and exposes UI state.
///
/// This controller contains no persistence or authentication rules.
/// Those responsibilities remain in AuthRepository.
class AuthProvider extends ChangeNotifier {
  AuthProvider(this._repository);

  final AuthRepository _repository;

  bool _isLoading = false;
  UserModel? _currentUser;
  String? _errorMessage;
  String? _successMessage;

  bool get isLoading => _isLoading;
  UserModel? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  bool get isAuthenticated => _currentUser != null;

  Future<bool> login(LoginRequest request) {
    return _execute(() async {
      _currentUser = await _repository.login(request);
    }, success: 'Login successful.');
  }

  Future<bool> register(RegisterRequest request) {
    return _execute(() async {
      await _repository.register(request);
    }, success: 'Account created successfully.');
  }

  Future<bool> sendPasswordResetCode(PasswordResetRequest request) {
    return _execute(() async {
      await _repository.sendPasswordResetCode(request);
    }, success: 'Verification code sent successfully.');
  }

  Future<bool> resetPassword(ResetPasswordRequest request) {
    return _execute(() async {
      await _repository.resetPassword(request);
    }, success: 'Password updated successfully.');
  }

  Future<bool> _execute(
    Future<void> Function() operation, {
    required String success,
  }) async {
    if (_isLoading) {
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      await operation();
      _successMessage = success;
      return true;
    } on AuthException catch (exception) {
      _errorMessage = exception.message;
      return false;
    } catch (_) {
      _errorMessage = 'An unexpected error occurred. Please try again.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearMessages() {
    if (_errorMessage == null && _successMessage == null) {
      return;
    }

    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }
}
