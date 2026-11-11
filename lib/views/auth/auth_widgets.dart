import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const Color authNavy = Color(0xFF172554);
const Color authBlue = Color(0xFF2455A6);
const Color authMuted = Color(0xFF64748B);
const Color authCanvas = Color(0xFFF3F6FC);

String? bilingualValidationMessage(String? message) {
  if (message == null) {
    return null;
  }

  const translations = <String, String>{
    'Please enter your Academic ID or Email':
        'يرجى إدخال المعرف الأكاديمي أو البريد الإلكتروني\nPlease enter your Academic ID or Email',
    'Must contain at least 5 characters':
        'يجب ألا يقل الإدخال عن 5 خانات\nMust contain at least 5 characters',
    'Please enter your password':
        'يرجى إدخال كلمة المرور\nPlease enter your password',
    'Password must be at least 6 characters':
        'يجب ألا تقل كلمة المرور عن 6 محارف\nPassword must be at least 6 characters',
    'Please enter your full name':
        'يرجى إدخال الاسم الكامل\nPlease enter your full name',
    'Name must contain at least 3 characters':
        'يجب ألا يقل الاسم عن 3 محارف\nName must contain at least 3 characters',
    'Please enter your Academic ID':
        'يرجى إدخال الرقم الأكاديمي\nPlease enter your Academic ID',
    'Academic ID must contain 9 or 10 digits':
        'الرقم الأكاديمي يجب أن يتكون من 9 أو 10 أرقام\nAcademic ID must contain 9 or 10 digits',
    'Please enter your university email':
        'يرجى إدخال البريد الجامعي\nPlease enter your university email',
    'Please enter a valid email address':
        'يرجى إدخال بريد إلكتروني صحيح\nPlease enter a valid email address',
    'Password must contain at least 8 characters':
        'كلمة المرور يجب ألا تقل عن 8 محارف\nPassword must contain at least 8 characters',
    'Password must contain an uppercase letter':
        'يجب أن تحتوي كلمة المرور على حرف إنجليزي كبير\nPassword must contain an uppercase letter',
    'Password must contain a number':
        'يجب أن تحتوي كلمة المرور على رقم واحد على الأقل\nPassword must contain a number',
    'Please confirm your password':
        'يرجى تأكيد كلمة المرور\nPlease confirm your password',
    'Passwords do not match':
        'كلمتا المرور غير متطابقتين\nPasswords do not match',
    'Please enter your email or Academic ID':
        'يرجى إدخال البريد الإلكتروني أو الرقم الأكاديمي\nPlease enter your email or Academic ID',
    'Enter a valid email or Academic ID':
        'يرجى إدخال بريد صحيح أو رقم أكاديمي صحيح\nEnter a valid email or Academic ID',
    'Please enter the verification code':
        'يرجى إدخال رمز التحقق\nPlease enter the verification code',
    'OTP must contain exactly 6 digits':
        'رمز التحقق يجب أن يتكون من 6 أرقام بالضبط\nOTP must contain exactly 6 digits',
    'You must accept the academic terms':
        'يجب الموافقة على اللوائح والشروط الأكاديمية\nYou must accept the academic terms',
  };

  return translations[message] ?? 'يرجى التحقق من البيانات المدخلة\n$message';
}

String bilingualAuthMessage(String message) {
  const translations = <String, String>{
    'All registration fields are required.':
        'جميع حقول التسجيل مطلوبة\nAll registration fields are required.',
    'You must accept the academic terms and conditions.':
        'يجب الموافقة على اللوائح والشروط الأكاديمية\nYou must accept the academic terms and conditions.',
    'This Academic ID is already registered.':
        'هذا الرقم الأكاديمي مسجل مسبقًا\nThis Academic ID is already registered.',
    'This email is already registered.':
        'هذا البريد الإلكتروني مسجل مسبقًا\nThis email is already registered.',
    'Academic ID/email and password are required.':
        'الرقم الأكاديمي أو البريد وكلمة المرور مطلوبة\nAcademic ID/email and password are required.',
    'Invalid Academic ID/email or password.':
        'الرقم الأكاديمي أو البريد أو كلمة المرور غير صحيحة\nInvalid Academic ID/email or password.',
    'Enter your email or Academic ID.':
        'أدخل البريد الإلكتروني أو الرقم الأكاديمي\nEnter your email or Academic ID.',
    'No account was found for this identifier.':
        'لم يتم العثور على حساب بهذه البيانات\nNo account was found for this identifier.',
    'The verification code is invalid or expired.':
        'رمز التحقق غير صحيح أو منتهي الصلاحية\nThe verification code is invalid or expired.',
    'The new password is required.':
        'كلمة المرور الجديدة مطلوبة\nThe new password is required.',
    'An unexpected error occurred. Please try again.':
        'حدث خطأ غير متوقع، يرجى المحاولة مجددًا\nAn unexpected error occurred. Please try again.',
    'Login successful.': 'تم تسجيل الدخول بنجاح\nLogin successful.',
    'Account created successfully.':
        'تم إنشاء الحساب بنجاح\nAccount created successfully.',
    'Verification code sent successfully.':
        'تم إنشاء رمز التحقق التجريبي\nVerification code generated successfully.',
    'Password updated successfully.':
        'تم تحديث كلمة المرور بنجاح\nPassword updated successfully.',
  };

  return translations[message] ?? 'حدث خطأ، يرجى المحاولة مرة أخرى\n$message';
}

class AuthPageShell extends StatelessWidget {
  const AuthPageShell({
    super.key,
    required this.arabicTitle,
    required this.englishTitle,
    required this.arabicSubtitle,
    required this.englishSubtitle,
    required this.icon,
    required this.child,
  });

  final String arabicTitle;
  final String englishTitle;
  final String arabicSubtitle;
  final String englishSubtitle;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: authCanvas,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xFFE7EEFC), Color(0xFFF7F9FD), Color(0xFFEFF4FB)],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 26, 20, 36),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 8),
                        Container(
                          width: 68,
                          height: 68,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: authBlue,
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: authBlue.withValues(alpha: 0.20),
                                blurRadius: 22,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.school_rounded,
                            color: Colors.white,
                            size: 34,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'بوابة الطالب',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: authNavy,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Text(
                          'STUDENT PORTAL',
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                            color: authMuted,
                            fontSize: 11,
                            letterSpacing: 2.2,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 28),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(icon, color: authBlue, size: 23),
                            const SizedBox(width: 9),
                            Flexible(
                              child: Text(
                                arabicTitle,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: authNavy,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          englishTitle,
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.ltr,
                          style: const TextStyle(
                            color: authBlue,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          arabicSubtitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: authMuted,
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                        Text(
                          englishSubtitle,
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.ltr,
                          style: const TextStyle(
                            color: authMuted,
                            fontSize: 12,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: const Color(0xFFE5EAF3)),
                            boxShadow: [
                              BoxShadow(
                                color: authNavy.withValues(alpha: 0.07),
                                blurRadius: 28,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          child: child,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'نظام مصادقة طلابي تجريبي',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: authMuted, fontSize: 11),
                        ),
                        const Text(
                          'STUDENT AUTHENTICATION DEMO',
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                            color: authMuted,
                            fontSize: 10,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class BilingualField extends StatelessWidget {
  const BilingualField({
    super.key,
    required this.fieldKey,
    required this.controller,
    required this.arabicLabel,
    required this.englishLabel,
    required this.validator,
    required this.icon,
    this.keyboardType,
    this.textDirection = TextDirection.ltr,
    this.inputFormatters,
    this.maxLength,
    this.textInputAction,
    this.autofillHints,
  });

  final Key fieldKey;
  final TextEditingController controller;
  final String arabicLabel;
  final String englishLabel;
  final String? Function(String?)? validator;
  final IconData icon;
  final TextInputType? keyboardType;
  final TextDirection textDirection;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          arabicLabel,
          style: const TextStyle(
            color: authNavy,
            fontWeight: FontWeight.w800,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          englishLabel,
          textDirection: TextDirection.ltr,
          style: const TextStyle(
            color: authMuted,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          key: fieldKey,
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          textDirection: textDirection,
          inputFormatters: inputFormatters,
          maxLength: maxLength,
          textInputAction: textInputAction,
          autofillHints: autofillHints,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: authBlue, size: 21),
            filled: true,
            fillColor: const Color(0xFFF8FAFD),
            counterText: '',
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFDCE4F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFDCE4F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: authBlue, width: 1.6),
            ),
            errorMaxLines: 3,
          ),
        ),
      ],
    );
  }
}

class BilingualPasswordField extends StatefulWidget {
  const BilingualPasswordField({
    super.key,
    required this.fieldKey,
    required this.controller,
    required this.arabicLabel,
    required this.englishLabel,
    required this.validator,
    this.textInputAction,
    this.autofillHints,
  });

  final Key fieldKey;
  final TextEditingController controller;
  final String arabicLabel;
  final String englishLabel;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;

  @override
  State<BilingualPasswordField> createState() => _BilingualPasswordFieldState();
}

class _BilingualPasswordFieldState extends State<BilingualPasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.arabicLabel,
          style: const TextStyle(
            color: authNavy,
            fontWeight: FontWeight.w800,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          widget.englishLabel,
          textDirection: TextDirection.ltr,
          style: const TextStyle(
            color: authMuted,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          key: widget.fieldKey,
          controller: widget.controller,
          validator: widget.validator,
          obscureText: _obscure,
          textDirection: TextDirection.ltr,
          textInputAction: widget.textInputAction,
          autofillHints: widget.autofillHints,
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.lock_outline_rounded,
              color: authBlue,
              size: 21,
            ),
            suffixIcon: IconButton(
              tooltip: _obscure
                  ? 'إظهار كلمة المرور | Show password'
                  : 'إخفاء كلمة المرور | Hide password',
              onPressed: () => setState(() => _obscure = !_obscure),
              icon: Icon(
                _obscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: authMuted,
              ),
            ),
            filled: true,
            fillColor: const Color(0xFFF8FAFD),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFDCE4F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFDCE4F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: authBlue, width: 1.6),
            ),
            errorMaxLines: 3,
          ),
        ),
      ],
    );
  }
}

class AuthPrimaryButton extends StatelessWidget {
  const AuthPrimaryButton({
    super.key,
    required this.arabicLabel,
    required this.englishLabel,
    required this.onPressed,
    this.isLoading = false,
    this.buttonKey,
  });

  final String arabicLabel;
  final String englishLabel;
  final VoidCallback onPressed;
  final bool isLoading;
  final Key? buttonKey;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        key: buttonKey,
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: authBlue,
          foregroundColor: Colors.white,
          disabledBackgroundColor: authBlue.withValues(alpha: 0.55),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 23,
                height: 23,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: Colors.white,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    arabicLabel,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    englishLabel,
                    textDirection: TextDirection.ltr,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class AuthTextLink extends StatelessWidget {
  const AuthTextLink({
    super.key,
    required this.arabicLabel,
    required this.englishLabel,
    required this.onPressed,
    this.linkKey,
  });

  final String arabicLabel;
  final String englishLabel;
  final VoidCallback onPressed;
  final Key? linkKey;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      key: linkKey,
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: authBlue,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            arabicLabel,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          Text(
            englishLabel,
            textDirection: TextDirection.ltr,
            style: const TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class AuthFeedback extends StatelessWidget {
  const AuthFeedback({super.key, this.errorMessage, this.successMessage});

  final String? errorMessage;
  final String? successMessage;

  @override
  Widget build(BuildContext context) {
    final isError = errorMessage != null;
    final message = errorMessage ?? successMessage;

    if (message == null) {
      return const SizedBox.shrink();
    }

    final color = isError ? const Color(0xFFB42318) : const Color(0xFF167647);
    final background = isError
        ? const Color(0xFFFFF1F0)
        : const Color(0xFFECFDF3);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 4, bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isError ? Icons.error_outline_rounded : Icons.check_circle_outline,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              bilingualAuthMessage(message),
              textAlign: TextAlign.right,
              style: TextStyle(
                color: color,
                fontSize: 12,
                height: 1.55,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthInfoCard extends StatelessWidget {
  const AuthInfoCard({
    super.key,
    required this.arabicText,
    required this.englishText,
    this.icon = Icons.info_outline_rounded,
    this.warning = false,
  });

  final String arabicText;
  final String englishText;
  final IconData icon;
  final bool warning;

  @override
  Widget build(BuildContext context) {
    final color = warning ? const Color(0xFF9A6700) : authBlue;
    final background = warning
        ? const Color(0xFFFFF8E6)
        : const Color(0xFFEFF5FF);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: color.withValues(alpha: 0.16)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 21),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  arabicText,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    height: 1.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  englishText,
                  textDirection: TextDirection.ltr,
                  style: TextStyle(color: color, fontSize: 11, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
