import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../models/reset_password_request.dart';
import '../../utils/form_validators.dart';
import 'auth_widgets.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({
    super.key,
    required this.identifier,
  });

  final String identifier;

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _updatePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final success = await context.read<AuthProvider>().resetPassword(
      ResetPasswordRequest(
        identifier: widget.identifier,
        otp: _otpController.text.trim(),
        newPassword: _passwordController.text,
      ),
    );

    if (!mounted || !success) {
      return;
    }

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          key: const ValueKey('reset_success_dialog'),
          icon: const Icon(
            Icons.check_circle_rounded,
            color: Color(0xFF167647),
            size: 44,
          ),
          title: const Text(
            'تم تحديث كلمة المرور',
            textAlign: TextAlign.center,
          ),
          content: const Text(
            'يمكنك الآن تسجيل الدخول باستخدام كلمة المرور الجديدة.\n'
            'You can now sign in with your new password.',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            FilledButton(
              key: const ValueKey('reset_success_ok'),
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('العودة للدخول | Back to Login'),
            ),
          ],
        );
      },
    );

    if (!mounted) {
      return;
    }

    context.read<AuthProvider>().clearMessages();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Builder(
      builder: (context) {
        return AuthPageShell(
          arabicTitle: 'تعيين كلمة مرور جديدة',
          englishTitle: 'Reset Password',
          arabicSubtitle: 'أدخل رمز التحقق ثم اختر كلمة مرور جديدة',
          englishSubtitle:
              'Enter the verification code and choose a new password.',
          icon: Icons.password_rounded,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AuthInfoCard(
                  icon: Icons.mark_email_read_outlined,
                  arabicText: 'طلب الاستعادة للحساب: ${widget.identifier}',
                  englishText: 'Password reset requested for this account.',
                ),
                const SizedBox(height: 10),
                const AuthInfoCard(
                  icon: Icons.science_outlined,
                  warning: true,
                  arabicText: 'وضع تجريبي: استخدم رمز الاختبار 123456.',
                  englishText: 'Demo mode: use test OTP 123456.',
                ),
                const SizedBox(height: 18),
                BilingualField(
                  fieldKey: const ValueKey('reset_otp'),
                  controller: _otpController,
                  arabicLabel: 'رمز التحقق',
                  englishLabel: 'Verification Code (6 digits)',
                  icon: Icons.pin_rounded,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  maxLength: 6,
                  textInputAction: TextInputAction.next,
                  validator: (value) =>
                      bilingualValidationMessage(FormValidators.otp(value)),
                ),
                const SizedBox(height: 16),
                BilingualPasswordField(
                  fieldKey: const ValueKey('reset_new_password'),
                  controller: _passwordController,
                  arabicLabel: 'كلمة المرور الجديدة',
                  englishLabel: 'New Password',
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.newPassword],
                  validator: (value) => bilingualValidationMessage(
                    FormValidators.strongPassword(value),
                  ),
                ),
                const SizedBox(height: 16),
                BilingualPasswordField(
                  fieldKey: const ValueKey('reset_confirm_password'),
                  controller: _confirmPasswordController,
                  arabicLabel: 'تأكيد كلمة المرور الجديدة',
                  englishLabel: 'Confirm New Password',
                  textInputAction: TextInputAction.done,
                  validator: (value) => bilingualValidationMessage(
                    FormValidators.confirmPassword(
                      value,
                      _passwordController.text,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                AuthFeedback(
                  errorMessage: auth.errorMessage,
                  successMessage: auth.successMessage,
                ),
                AuthPrimaryButton(
                  buttonKey: const ValueKey('reset_submit'),
                  arabicLabel: 'تحديث كلمة المرور',
                  englishLabel: 'Update Password',
                  isLoading: auth.isLoading,
                  onPressed: _updatePassword,
                ),
                const SizedBox(height: 12),
                Center(
                  child: AuthTextLink(
                    linkKey: const ValueKey('reset_back'),
                    arabicLabel: 'العودة',
                    englishLabel: 'Back',
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
