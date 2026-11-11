import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../models/register_request.dart';
import '../../utils/form_validators.dart';
import 'auth_widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _academicIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _acceptedTerms = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _academicIdController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final success = await context.read<AuthProvider>().register(
      RegisterRequest(
        fullName: _fullNameController.text.trim(),
        academicId: _academicIdController.text.trim(),
        universityEmail: _emailController.text.trim(),
        password: _passwordController.text,
        acceptedTerms: _acceptedTerms,
      ),
    );

    if (!mounted) {
      return;
    }

    if (success) {
      context.read<AuthProvider>().clearMessages();
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Builder(
      builder: (context) {
        return AuthPageShell(
          arabicTitle: 'إنشاء حساب طالب',
          englishTitle: 'Student Registration',
          arabicSubtitle: 'أكمل البيانات التالية لإنشاء حسابك الأكاديمي',
          englishSubtitle:
              'Complete the following details to create your student account.',
          icon: Icons.person_add_alt_1_rounded,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BilingualField(
                  fieldKey: const ValueKey('register_full_name'),
                  controller: _fullNameController,
                  arabicLabel: 'الاسم الكامل',
                  englishLabel: 'Full Name',
                  icon: Icons.badge_outlined,
                  textDirection: TextDirection.rtl,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.name],
                  validator: (value) => bilingualValidationMessage(
                    FormValidators.fullName(value),
                  ),
                ),
                const SizedBox(height: 16),
                BilingualField(
                  fieldKey: const ValueKey('register_academic_id'),
                  controller: _academicIdController,
                  arabicLabel: 'الرقم الأكاديمي',
                  englishLabel: 'Academic ID (9–10 digits)',
                  icon: Icons.numbers_rounded,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  maxLength: 10,
                  textInputAction: TextInputAction.next,
                  validator: (value) => bilingualValidationMessage(
                    FormValidators.academicId(value),
                  ),
                ),
                const SizedBox(height: 16),
                BilingualField(
                  fieldKey: const ValueKey('register_email'),
                  controller: _emailController,
                  arabicLabel: 'البريد الجامعي',
                  englishLabel: 'University Email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.email],
                  validator: (value) => bilingualValidationMessage(
                    FormValidators.universityEmail(value),
                  ),
                ),
                const SizedBox(height: 16),
                BilingualPasswordField(
                  fieldKey: const ValueKey('register_password'),
                  controller: _passwordController,
                  arabicLabel: 'كلمة المرور',
                  englishLabel: 'Password',
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.newPassword],
                  validator: (value) => bilingualValidationMessage(
                    FormValidators.strongPassword(value),
                  ),
                ),
                const SizedBox(height: 16),
                BilingualPasswordField(
                  fieldKey: const ValueKey('register_confirm_password'),
                  controller: _confirmPasswordController,
                  arabicLabel: 'تأكيد كلمة المرور',
                  englishLabel: 'Confirm Password',
                  textInputAction: TextInputAction.done,
                  validator: (value) => bilingualValidationMessage(
                    FormValidators.confirmPassword(
                      value,
                      _passwordController.text,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                FormField<bool>(
                  key: const ValueKey('register_terms_field'),
                  initialValue: false,
                  validator: (value) => bilingualValidationMessage(
                    FormValidators.termsAccepted(value),
                  ),
                  builder: (field) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CheckboxListTile(
                          key: const ValueKey('register_terms_checkbox'),
                          value: field.value ?? false,
                          activeColor: authBlue,
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (value) {
                            _acceptedTerms = value ?? false;
                            field.didChange(_acceptedTerms);
                          },
                          title: const Text(
                            'أوافق على اللوائح والشروط الأكاديمية',
                            style: TextStyle(
                              color: authNavy,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          subtitle: const Text(
                            'I accept the academic rules and terms.',
                            textDirection: TextDirection.ltr,
                            style: TextStyle(color: authMuted, fontSize: 10),
                          ),
                        ),
                        if (field.errorText != null)
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 12,
                              bottom: 8,
                            ),
                            child: Text(
                              field.errorText!,
                              style: const TextStyle(
                                color: Color(0xFFB42318),
                                fontSize: 11,
                                height: 1.45,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                AuthFeedback(
                  errorMessage: auth.errorMessage,
                  successMessage: auth.successMessage,
                ),
                AuthPrimaryButton(
                  buttonKey: const ValueKey('register_submit'),
                  arabicLabel: 'إنشاء الحساب',
                  englishLabel: 'Create Account',
                  isLoading: auth.isLoading,
                  onPressed: _submit,
                ),
                const SizedBox(height: 12),
                Center(
                  child: AuthTextLink(
                    linkKey: const ValueKey('register_back_to_login'),
                    arabicLabel: 'العودة إلى تسجيل الدخول',
                    englishLabel: 'Back to Login',
                    onPressed: () => Navigator.of(context).pop(false),
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
