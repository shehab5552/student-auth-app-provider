import '../models/login_request.dart';
import '../models/password_reset_request.dart';
import '../models/register_request.dart';
import '../models/reset_password_request.dart';
import '../models/user_model.dart';
import 'auth_exception.dart';
import 'auth_repository.dart';

/// In-memory authentication repository for the coursework demonstration.
///
/// This implementation simulates network latency. It does not contact a
/// server, send a real email, or persist accounts after the app process ends.
/// The fixed OTP is intentionally for demonstration/testing only.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    Duration simulationDelay = const Duration(milliseconds: 400),
  }) : _simulationDelay = simulationDelay;

  static const String demoOtp = '123456';

  final Duration _simulationDelay;
  final Map<String, _StoredUser> _usersByAcademicId = {};
  final Map<String, String> _pendingOtpByAcademicId = {};

  Future<void> _simulateNetwork() async {
    if (_simulationDelay > Duration.zero) {
      await Future<void>.delayed(_simulationDelay);
    }
  }

  String _normalize(String value) => value.trim().toLowerCase();

  _StoredUser? _findUserByIdentifier(String identifier) {
    final normalizedIdentifier = _normalize(identifier);

    for (final user in _usersByAcademicId.values) {
      if (_normalize(user.academicId) == normalizedIdentifier ||
          _normalize(user.universityEmail) == normalizedIdentifier) {
        return user;
      }
    }

    return null;
  }

  @override
  Future<UserModel> register(RegisterRequest request) async {
    await _simulateNetwork();

    final fullName = request.fullName.trim();
    final academicId = request.academicId.trim();
    final universityEmail = request.universityEmail.trim();

    if (fullName.isEmpty ||
        academicId.isEmpty ||
        universityEmail.isEmpty ||
        request.password.isEmpty) {
      throw const AuthException('All registration fields are required.');
    }

    if (!request.acceptedTerms) {
      throw const AuthException(
        'You must accept the academic terms and conditions.',
      );
    }

    final academicIdKey = _normalize(academicId);
    final emailKey = _normalize(universityEmail);

    if (_usersByAcademicId.containsKey(academicIdKey)) {
      throw const AuthException('This Academic ID is already registered.');
    }

    final emailAlreadyUsed = _usersByAcademicId.values.any(
      (user) => _normalize(user.universityEmail) == emailKey,
    );

    if (emailAlreadyUsed) {
      throw const AuthException('This email is already registered.');
    }

    final storedUser = _StoredUser(
      fullName: fullName,
      academicId: academicId,
      universityEmail: universityEmail,
      password: request.password,
    );

    _usersByAcademicId[academicIdKey] = storedUser;
    return storedUser.toUserModel();
  }

  @override
  Future<UserModel> login(LoginRequest request) async {
    await _simulateNetwork();

    if (request.identifier.trim().isEmpty || request.password.isEmpty) {
      throw const AuthException('Academic ID/email and password are required.');
    }

    final storedUser = _findUserByIdentifier(request.identifier);

    if (storedUser == null || storedUser.password != request.password) {
      throw const AuthException('Invalid Academic ID/email or password.');
    }

    return storedUser.toUserModel();
  }

  @override
  Future<void> sendPasswordResetCode(PasswordResetRequest request) async {
    await _simulateNetwork();

    if (request.identifier.trim().isEmpty) {
      throw const AuthException('Enter your email or Academic ID.');
    }

    final storedUser = _findUserByIdentifier(request.identifier);

    if (storedUser == null) {
      throw const AuthException('No account was found for this identifier.');
    }

    _pendingOtpByAcademicId[_normalize(storedUser.academicId)] = demoOtp;
  }

  @override
  Future<void> resetPassword(ResetPasswordRequest request) async {
    await _simulateNetwork();

    final storedUser = _findUserByIdentifier(request.identifier);
    if (storedUser == null) {
      throw const AuthException('No account was found for this identifier.');
    }

    final academicIdKey = _normalize(storedUser.academicId);
    final expectedOtp = _pendingOtpByAcademicId[academicIdKey];

    if (expectedOtp == null || request.otp != expectedOtp) {
      throw const AuthException('The verification code is invalid or expired.');
    }

    if (request.newPassword.isEmpty) {
      throw const AuthException('The new password is required.');
    }

    storedUser.password = request.newPassword;
    _pendingOtpByAcademicId.remove(academicIdKey);
  }
}

class _StoredUser {
  final String fullName;
  final String academicId;
  final String universityEmail;
  String password;

  _StoredUser({
    required this.fullName,
    required this.academicId,
    required this.universityEmail,
    required this.password,
  });

  UserModel toUserModel() {
    return UserModel(
      fullName: fullName,
      academicId: academicId,
      universityEmail: universityEmail,
    );
  }
}
