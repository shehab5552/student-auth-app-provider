import 'package:flutter_test/flutter_test.dart';
import 'package:student_auth_app_provider/utils/form_validators.dart';

void main() {
  group('FormValidators.loginIdentifier', () {
    test('rejects empty and shorter than five characters', () {
      expect(FormValidators.loginIdentifier(''), isNotNull);
      expect(FormValidators.loginIdentifier('abcd'), isNotNull);
    });

    test('accepts five or more characters', () {
      expect(FormValidators.loginIdentifier('abcde'), isNull);
      expect(FormValidators.loginIdentifier('student@uni.edu'), isNull);
    });
  });

  group('FormValidators.loginPassword', () {
    test('requires at least six characters', () {
      expect(FormValidators.loginPassword('12345'), isNotNull);
      expect(FormValidators.loginPassword('123456'), isNull);
    });
  });

  group('FormValidators.fullName', () {
    test('requires at least three trimmed characters', () {
      expect(FormValidators.fullName('  '), isNotNull);
      expect(FormValidators.fullName('Al'), isNotNull);
      expect(FormValidators.fullName('Ali'), isNull);
      expect(FormValidators.fullName('  Ali  '), isNull);
    });
  });

  group('FormValidators.academicId', () {
    test('accepts only 9 or 10 digits', () {
      expect(FormValidators.academicId('123456789'), isNull);
      expect(FormValidators.academicId('1234567890'), isNull);
      expect(FormValidators.academicId('12345678'), isNotNull);
      expect(FormValidators.academicId('12345678901'), isNotNull);
      expect(FormValidators.academicId('12345abcd'), isNotNull);
    });
  });

  group('FormValidators.universityEmail', () {
    test('accepts standard email syntax', () {
      expect(FormValidators.universityEmail('student@university.edu'), isNull);
    });

    test('rejects malformed email', () {
      expect(
        FormValidators.universityEmail('student-university.edu'),
        isNotNull,
      );
      expect(FormValidators.universityEmail('student@'), isNotNull);
    });
  });

  group('FormValidators.strongPassword', () {
    test('accepts password meeting all stated requirements', () {
      expect(FormValidators.strongPassword('Student1'), isNull);
    });

    test('rejects missing length, uppercase, or digit', () {
      expect(FormValidators.strongPassword('Ab1'), isNotNull);
      expect(FormValidators.strongPassword('student1'), isNotNull);
      expect(FormValidators.strongPassword('StudentX'), isNotNull);
    });
  });

  group('FormValidators.confirmPassword', () {
    test('requires exact match', () {
      expect(FormValidators.confirmPassword('Student1', 'Student1'), isNull);
      expect(FormValidators.confirmPassword('student1', 'Student1'), isNotNull);
      expect(FormValidators.confirmPassword('', 'Student1'), isNotNull);
    });
  });

  group('FormValidators.resetIdentifier', () {
    test('accepts email or 9-10 digit Academic ID', () {
      expect(FormValidators.resetIdentifier('student@university.edu'), isNull);
      expect(FormValidators.resetIdentifier('123456789'), isNull);
      expect(FormValidators.resetIdentifier('1234567890'), isNull);
    });

    test('rejects invalid identifiers', () {
      expect(FormValidators.resetIdentifier('12345678'), isNotNull);
      expect(FormValidators.resetIdentifier('not-an-email'), isNotNull);
    });
  });

  group('FormValidators.otp', () {
    test('accepts exactly six digits', () {
      expect(FormValidators.otp('123456'), isNull);
    });

    test('rejects any other format', () {
      expect(FormValidators.otp('12345'), isNotNull);
      expect(FormValidators.otp('1234567'), isNotNull);
      expect(FormValidators.otp('12a456'), isNotNull);
    });
  });

  group('FormValidators.termsAccepted', () {
    test('requires explicit acceptance', () {
      expect(FormValidators.termsAccepted(true), isNull);
      expect(FormValidators.termsAccepted(false), isNotNull);
      expect(FormValidators.termsAccepted(null), isNotNull);
    });
  });
}
