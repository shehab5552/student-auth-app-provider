import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../models/password_reset_request.dart';
import '../../utils/form_validators.dart';
import 'auth_widgets.dart';
import 'reset_password_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();

  @override
  void dispose() {
    _identifierController.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final identifier = _identifierController.text.trim();
    final success = await context.read<AuthProvider>().sendPasswordResetCode(
      PasswordResetRequest(identifier: identifier),
    );

    if (!mounted) {
      return;
    }

    if (success) {
      context.read<AuthProvider>().clearMessages();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFF167647),
          content: Text(
            'تم إنشاء رمز التحقق التجريبي: 123456\n'
            'Demo verification code generated: 123456',
            textAlign: TextAlign.center,
          ),
        ),
      );

      await Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (_) => ResetPasswordPage(
            identifier: identifier,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Builder(
      builder: (context) {
        return AuthPageShell(
          arabicTitle: 'استعادة كلمة المرور',
          englishTitle: 'Forgot Password',
          arabicSubtitle: 'أدخل بريدك الجامعي أو رقمك الأكاديمي للمتابعة',
          englishSubtitle:
              'Enter your university email or Academic ID to continue.',
          icon: Icons.mark_email_unread_outlined,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AuthInfoCard(
                  icon: Icons.verified_user_outlined,
                  arabicText:
                      'أدخل بيانات حسابك. في النظام الفعلي يُرسل رمز تحقق إلى وسيلة الاتصال المسجلة.',
                  englishText:
                      'Enter your account identifier. A real system would send a verification code to your registered contact.',
                ),
                const SizedBox(height: 18),
                BilingualField(
                  fieldKey: const ValueKey('forgot_identifier'),
                  controller: _identifierController,
                  arabicLabel: 'البريد الإلكتروني أو الرقم الأكاديمي',
                  englishLabel: 'Email or Academic ID',
                  icon: Icons.alternate_email_rounded,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  validator: (value) => bilingualValidationMessage(
                    FormValidators.resetIdentifier(value),
                  ),
                ),
                const SizedBox(height: 16),
                const AuthInfoCard(
                  icon: Icons.science_outlined,
                  warning: true,
                  arabicText:
                      'وضع تجريبي: لا يتم إرسال بريد حقيقي. رمز الاختبار هو 123456.',
                  englishText:
                      'Demo mode: no real email is sent. The test OTP is 123456.',
                ),
                const SizedBox(height: 16),
                AuthFeedback(
                  errorMessage: auth.errorMessage,
                  successMessage: auth.successMessage,
                ),
                AuthPrimaryButton(
                  buttonKey: const ValueKey('forgot_submit'),
                  arabicLabel: 'إرسال رمز التحقق',
                  englishLabel: 'Send Verification Code',
                  isLoading: auth.isLoading,
                  onPressed: _sendCode,
                ),
                const SizedBox(height: 12),
                Center(
                  child: AuthTextLink(
                    linkKey: const ValueKey('forgot_back_to_login'),
                    arabicLabel: 'العودة إلى تسجيل الدخول',
                    englishLabel: 'Back to Login',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
