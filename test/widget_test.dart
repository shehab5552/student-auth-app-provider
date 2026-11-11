import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_auth_app_provider/main.dart';

void main() {
  Future<void> openRegistration(WidgetTester tester) async {
    await tester.ensureVisible(find.byKey(const ValueKey('go_register')));
    await tester.tap(find.byKey(const ValueKey('go_register')));
    await tester.pumpAndSettle();
  }

  Future<void> enterTextVisible(
    WidgetTester tester,
    String key,
    String value,
  ) async {
    final finder = find.byKey(ValueKey(key));
    await tester.ensureVisible(finder);
    await tester.enterText(finder, value);
  }

  Future<void> registerStudent(WidgetTester tester) async {
    await openRegistration(tester);

    await enterTextVisible(tester, 'register_full_name', 'Student Example');
    await enterTextVisible(tester, 'register_academic_id', '123456789');
    await enterTextVisible(tester, 'register_email', 'student@university.edu');
    await enterTextVisible(tester, 'register_password', 'Student123');
    await enterTextVisible(tester, 'register_confirm_password', 'Student123');

    // Dismiss the last focused field before interacting with the terms control.
    // This prevents the software keyboard from reducing the visible scroll area.
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();

    final termsTile = find.byKey(const ValueKey('register_terms_checkbox'));
    final termsCheckbox = find.descendant(
      of: termsTile,
      matching: find.byType(Checkbox),
    );

    // Tap the actual Checkbox rather than the center of the outer ListTile.
    await tester.ensureVisible(termsCheckbox);
    await tester.pumpAndSettle();
    await tester.tap(termsCheckbox);
    await tester.pumpAndSettle();

    expect(tester.widget<Checkbox>(termsCheckbox).value, isTrue);

    await tester.ensureVisible(find.byKey(const ValueKey('register_submit')));
    await tester.tap(find.byKey(const ValueKey('register_submit')));
    await tester.pumpAndSettle();
  }

  Future<void> login(WidgetTester tester, {required String password}) async {
    await enterTextVisible(tester, 'login_identifier', '123456789');
    await enterTextVisible(tester, 'login_password', password);
    await tester.ensureVisible(find.byKey(const ValueKey('login_submit')));
    await tester.tap(find.byKey(const ValueKey('login_submit')));
    await tester.pumpAndSettle();
  }

  testWidgets('shows bilingual student login screen', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Student Login'), findsOneWidget);
    expect(find.byKey(const ValueKey('login_identifier')), findsOneWidget);
    expect(find.byKey(const ValueKey('login_password')), findsOneWidget);
    expect(find.byKey(const ValueKey('login_remember_me')), findsOneWidget);
    expect(find.text('0'), findsNothing);
  });

  testWidgets('login form validates empty required fields', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.ensureVisible(find.byKey(const ValueKey('login_submit')));
    await tester.tap(find.byKey(const ValueKey('login_submit')));
    await tester.pumpAndSettle();

    expect(find.textContaining('يرجى إدخال المعرف الأكاديمي'), findsOneWidget);
    expect(find.textContaining('يرجى إدخال كلمة المرور'), findsOneWidget);
  });

  testWidgets('student can register and then log in', (tester) async {
    await tester.pumpWidget(const MyApp());

    await registerStudent(tester);

    expect(find.text('Student Login'), findsOneWidget);
    expect(find.textContaining('تم إنشاء الحساب بنجاح'), findsOneWidget);

    await login(tester, password: 'Student123');

    expect(find.textContaining('مرحباً، Student Example'), findsOneWidget);
    expect(find.text('Academic ID: 123456789'), findsOneWidget);
    expect(find.byKey(const ValueKey('logout_button')), findsOneWidget);
  });

  testWidgets('student can request reset and sign in with new password', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await registerStudent(tester);

    await tester.ensureVisible(
      find.byKey(const ValueKey('go_forgot_password')),
    );
    await tester.tap(find.byKey(const ValueKey('go_forgot_password')));
    await tester.pumpAndSettle();

    await enterTextVisible(
      tester,
      'forgot_identifier',
      'student@university.edu',
    );
    await tester.ensureVisible(find.byKey(const ValueKey('forgot_submit')));
    await tester.tap(find.byKey(const ValueKey('forgot_submit')));
    await tester.pumpAndSettle();

    expect(find.text('تعيين كلمة مرور جديدة'), findsOneWidget);
    expect(find.textContaining('رمز الاختبار'), findsOneWidget);

    await enterTextVisible(tester, 'reset_otp', '123456');
    await enterTextVisible(tester, 'reset_new_password', 'NewStudent123');
    await enterTextVisible(tester, 'reset_confirm_password', 'NewStudent123');

    await tester.ensureVisible(find.byKey(const ValueKey('reset_submit')));
    await tester.tap(find.byKey(const ValueKey('reset_submit')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('reset_success_dialog')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('reset_success_ok')));
    await tester.pumpAndSettle();

    expect(find.text('Student Login'), findsOneWidget);

    await login(tester, password: 'NewStudent123');

    expect(find.textContaining('مرحباً، Student Example'), findsOneWidget);
  });
}
