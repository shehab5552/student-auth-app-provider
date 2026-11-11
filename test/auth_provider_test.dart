import 'package:flutter_test/flutter_test.dart';
import 'package:student_auth_app_provider/providers/auth_provider.dart';
import 'package:student_auth_app_provider/models/login_request.dart';
import 'package:student_auth_app_provider/models/password_reset_request.dart';
import 'package:student_auth_app_provider/models/register_request.dart';
import 'package:student_auth_app_provider/models/reset_password_request.dart';
import 'package:student_auth_app_provider/repositories/auth_repository_impl.dart';

void main() {
  late AuthRepositoryImpl repository;
  late AuthProvider controller;

  const registration = RegisterRequest(
    fullName: 'Student Example',
    academicId: '123456789',
    universityEmail: 'student@university.edu',
    password: 'Student123',
    acceptedTerms: true,
  );

  setUp(() {
    repository = AuthRepositoryImpl(simulationDelay: Duration.zero);
    controller = AuthProvider(repository);
  });

  tearDown(() {
    controller.dispose();
  });

  group('AuthProvider state', () {
    test('starts idle and unauthenticated', () {
      expect(controller.isLoading, isFalse);
      expect(controller.currentUser, isNull);
      expect(controller.isAuthenticated, isFalse);
      expect(controller.errorMessage, isNull);
      expect(controller.successMessage, isNull);
    });

    test('register exposes success state and returns true', () async {
      final result = await controller.register(registration);

      expect(result, isTrue);
      expect(controller.isLoading, isFalse);
      expect(controller.successMessage, 'Account created successfully.');
      expect(controller.errorMessage, isNull);
      expect(controller.currentUser, isNull);
    });

    test('login sets current user and authenticated state', () async {
      await repository.register(registration);

      final result = await controller.login(
        const LoginRequest(
          identifier: '123456789',
          password: 'Student123',
          rememberMe: false,
        ),
      );

      expect(result, isTrue);
      expect(controller.currentUser?.academicId, '123456789');
      expect(controller.isAuthenticated, isTrue);
      expect(controller.successMessage, 'Login successful.');
      expect(controller.errorMessage, isNull);
      expect(controller.isLoading, isFalse);
    });

    test(
      'login failure exposes repository error without authenticating',
      () async {
        final result = await controller.login(
          const LoginRequest(
            identifier: 'unknown@university.edu',
            password: 'Wrong123',
            rememberMe: false,
          ),
        );

        expect(result, isFalse);
        expect(controller.currentUser, isNull);
        expect(controller.isAuthenticated, isFalse);
        expect(
          controller.errorMessage,
          'Invalid Academic ID/email or password.',
        );
        expect(controller.successMessage, isNull);
        expect(controller.isLoading, isFalse);
      },
    );

    test('clearMessages clears success and error messages', () async {
      await controller.register(registration);
      expect(controller.successMessage, isNotNull);

      controller.clearMessages();

      expect(controller.successMessage, isNull);
      expect(controller.errorMessage, isNull);
    });

    test('logout clears the current user and messages', () async {
      await repository.register(registration);
      await controller.login(
        const LoginRequest(
          identifier: '123456789',
          password: 'Student123',
          rememberMe: false,
        ),
      );

      controller.logout();

      expect(controller.currentUser, isNull);
      expect(controller.isAuthenticated, isFalse);
      expect(controller.errorMessage, isNull);
      expect(controller.successMessage, isNull);
    });
  });

  group('AuthProvider password reset', () {
    setUp(() async {
      await repository.register(registration);
    });

    test('send code and reset password expose success states', () async {
      final sendResult = await controller.sendPasswordResetCode(
        const PasswordResetRequest(identifier: '123456789'),
      );

      expect(sendResult, isTrue);
      expect(controller.successMessage, 'Verification code sent successfully.');

      final resetResult = await controller.resetPassword(
        const ResetPasswordRequest(
          identifier: '123456789',
          otp: AuthRepositoryImpl.demoOtp,
          newPassword: 'NewStudent123',
        ),
      );

      expect(resetResult, isTrue);
      expect(controller.successMessage, 'Password updated successfully.');
      expect(controller.errorMessage, isNull);
      expect(controller.isLoading, isFalse);
    });

    test('reset failure exposes error and returns false', () async {
      final result = await controller.resetPassword(
        const ResetPasswordRequest(
          identifier: '123456789',
          otp: '000000',
          newPassword: 'NewStudent123',
        ),
      );

      expect(result, isFalse);
      expect(
        controller.errorMessage,
        'The verification code is invalid or expired.',
      );
      expect(controller.successMessage, isNull);
      expect(controller.isLoading, isFalse);
    });
  });
}
