import 'package:flutter_test/flutter_test.dart';
import 'package:student_auth_app_provider/models/login_request.dart';
import 'package:student_auth_app_provider/models/password_reset_request.dart';
import 'package:student_auth_app_provider/models/register_request.dart';
import 'package:student_auth_app_provider/models/reset_password_request.dart';
import 'package:student_auth_app_provider/repositories/auth_exception.dart';
import 'package:student_auth_app_provider/repositories/auth_repository_impl.dart';

void main() {
  late AuthRepositoryImpl repository;

  const validRegistration = RegisterRequest(
    fullName: 'Student Example',
    academicId: '123456789',
    universityEmail: 'student@university.edu',
    password: 'Student123',
    acceptedTerms: true,
  );

  setUp(() {
    repository = AuthRepositoryImpl(simulationDelay: Duration.zero);
  });

  group('AuthRepositoryImpl.register', () {
    test(
      'registers a student and returns a UserModel without password',
      () async {
        final user = await repository.register(validRegistration);

        expect(user.fullName, 'Student Example');
        expect(user.academicId, '123456789');
        expect(user.universityEmail, 'student@university.edu');
      },
    );

    test('rejects a duplicate Academic ID', () async {
      await repository.register(validRegistration);

      await expectLater(
        repository.register(validRegistration),
        throwsA(isA<AuthException>()),
      );
    });

    test('rejects a duplicate email regardless of letter case', () async {
      await repository.register(validRegistration);

      const duplicateEmail = RegisterRequest(
        fullName: 'Another Student',
        academicId: '987654321',
        universityEmail: 'STUDENT@UNIVERSITY.EDU',
        password: 'Another123',
        acceptedTerms: true,
      );

      await expectLater(
        repository.register(duplicateEmail),
        throwsA(isA<AuthException>()),
      );
    });

    test('rejects registration when terms are not accepted', () async {
      const request = RegisterRequest(
        fullName: 'Student Example',
        academicId: '123456789',
        universityEmail: 'student@university.edu',
        password: 'Student123',
        acceptedTerms: false,
      );

      await expectLater(
        repository.register(request),
        throwsA(isA<AuthException>()),
      );
    });
  });

  group('AuthRepositoryImpl.login', () {
    setUp(() async {
      await repository.register(validRegistration);
    });

    test('logs in using Academic ID', () async {
      final user = await repository.login(
        const LoginRequest(
          identifier: '123456789',
          password: 'Student123',
          rememberMe: false,
        ),
      );

      expect(user.academicId, '123456789');
    });

    test('logs in using email regardless of letter case', () async {
      final user = await repository.login(
        const LoginRequest(
          identifier: 'STUDENT@UNIVERSITY.EDU',
          password: 'Student123',
          rememberMe: true,
        ),
      );

      expect(user.universityEmail, 'student@university.edu');
    });

    test('rejects an incorrect password', () async {
      await expectLater(
        repository.login(
          const LoginRequest(
            identifier: '123456789',
            password: 'WrongPassword1',
            rememberMe: false,
          ),
        ),
        throwsA(isA<AuthException>()),
      );
    });

    test('rejects an unknown identifier', () async {
      await expectLater(
        repository.login(
          const LoginRequest(
            identifier: 'unknown@university.edu',
            password: 'Student123',
            rememberMe: false,
          ),
        ),
        throwsA(isA<AuthException>()),
      );
    });
  });

  group('Password reset flow', () {
    setUp(() async {
      await repository.register(validRegistration);
    });

    test('sends the demo reset code and updates the password', () async {
      await repository.sendPasswordResetCode(
        const PasswordResetRequest(identifier: '123456789'),
      );

      await repository.resetPassword(
        const ResetPasswordRequest(
          identifier: 'student@university.edu',
          otp: AuthRepositoryImpl.demoOtp,
          newPassword: 'NewStudent123',
        ),
      );

      final user = await repository.login(
        const LoginRequest(
          identifier: '123456789',
          password: 'NewStudent123',
          rememberMe: false,
        ),
      );

      expect(user.academicId, '123456789');
    });

    test('rejects an incorrect OTP and keeps the old password', () async {
      await repository.sendPasswordResetCode(
        const PasswordResetRequest(identifier: 'student@university.edu'),
      );

      await expectLater(
        repository.resetPassword(
          const ResetPasswordRequest(
            identifier: '123456789',
            otp: '000000',
            newPassword: 'NewStudent123',
          ),
        ),
        throwsA(isA<AuthException>()),
      );

      final user = await repository.login(
        const LoginRequest(
          identifier: '123456789',
          password: 'Student123',
          rememberMe: false,
        ),
      );

      expect(user.academicId, '123456789');
    });

    test('rejects reset when no code was requested', () async {
      await expectLater(
        repository.resetPassword(
          const ResetPasswordRequest(
            identifier: '123456789',
            otp: AuthRepositoryImpl.demoOtp,
            newPassword: 'NewStudent123',
          ),
        ),
        throwsA(isA<AuthException>()),
      );
    });

    test('rejects sending a code for an unknown identifier', () async {
      await expectLater(
        repository.sendPasswordResetCode(
          const PasswordResetRequest(identifier: 'nobody@university.edu'),
        ),
        throwsA(isA<AuthException>()),
      );
    });

    test('does not allow the same code to be reused after reset', () async {
      await repository.sendPasswordResetCode(
        const PasswordResetRequest(identifier: '123456789'),
      );

      await repository.resetPassword(
        const ResetPasswordRequest(
          identifier: '123456789',
          otp: AuthRepositoryImpl.demoOtp,
          newPassword: 'NewStudent123',
        ),
      );

      await expectLater(
        repository.resetPassword(
          const ResetPasswordRequest(
            identifier: '123456789',
            otp: AuthRepositoryImpl.demoOtp,
            newPassword: 'AnotherStudent123',
          ),
        ),
        throwsA(isA<AuthException>()),
      );
    });
  });
}
