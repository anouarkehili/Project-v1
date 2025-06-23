import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    const backgroundColor = Color(0xFF181829);
    const cardColor = Color(0xFF23233A);
    const inputFillColor = Color(0xFF23233A);
    const labelColor = Colors.white;
    const textColor = Colors.white70;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
              color: cardColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // زر الرجوع في الأعلى
                    Row(
                      children: [
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.deepPurple, size: 26),
                            onPressed: () => Navigator.pop(context),
                            tooltip: 'رجوع',
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                    // Logo with shadow and animation
                    Hero(
                      tag: 'logo',
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.deepPurple.withAlpha((0.3 * 255).toInt()),
                                blurRadius: 30,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'assets/images/logo.png',
                            height: 100,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'إنشاء حساب جديد',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ModernTextField(
                      controller: firstNameController,
                      label: 'الاسم الأول',
                      prefixIcon: const Icon(Icons.person, color: Colors.deepPurpleAccent),
                      fillColor: inputFillColor,
                      labelColor: labelColor,
                      textColor: textColor,
                    ),
                    const SizedBox(height: 12),
                    ModernTextField(
                      controller: lastNameController,
                      label: 'الاسم العائلي',
                      prefixIcon: const Icon(Icons.person_outline, color: Colors.deepPurpleAccent),
                      fillColor: inputFillColor,
                      labelColor: labelColor,
                      textColor: textColor,
                    ),
                    const SizedBox(height: 12),
                    ModernTextField(
                      controller: phoneController,
                      label: 'رقم الهاتف',
                      prefixIcon: const Icon(Icons.phone, color: Colors.deepPurpleAccent),
                      keyboardType: TextInputType.phone,
                      fillColor: inputFillColor,
                      labelColor: labelColor,
                      textColor: textColor,
                    ),
                    const SizedBox(height: 12),
                    ModernTextField(
                      controller: emailController,
                      label: 'البريد الإلكتروني',
                      prefixIcon: const Icon(Icons.email, color: Colors.deepPurpleAccent),
                      keyboardType: TextInputType.emailAddress,
                      fillColor: inputFillColor,
                      labelColor: labelColor,
                      textColor: textColor,
                    ),
                    const SizedBox(height: 12),
                    ModernTextField(
                      controller: passwordController,
                      label: 'كلمة المرور',
                      prefixIcon: const Icon(Icons.lock, color: Colors.deepPurpleAccent),
                      obscureText: true,
                      fillColor: inputFillColor,
                      labelColor: labelColor,
                      textColor: textColor,
                    ),

                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: إنشاء الحساب
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          elevation: 4,
                          shadowColor: Colors.deepPurple.withAlpha((0.18 * 255).toInt()),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.check_circle_outline, size: 22, color: Colors.white),
                            SizedBox(width: 10),
                            Text(
                              'تسجيل',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Expanded(child: Divider(thickness: 1.2, color: Colors.white24)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'أو',
                            style: TextStyle(color: Colors.white54, fontWeight: FontWeight.w500),
                          ),
                        ),
                        const Expanded(child: Divider(thickness: 1.2, color: Colors.white24)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // TODO: تسجيل عبر Facebook
                        },
                        icon: const Icon(Icons.facebook, color: Color(0xFF1877F3), size: 26),
                        label: const Text(
                          'التسجيل باستخدام Facebook',
                          style: TextStyle(
                            color: Color(0xFF1877F3),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF1877F3), width: 1.5),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          backgroundColor: backgroundColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'لديك حساب بالفعل؟ تسجيل الدخول',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ModernTextField widget definition
class ModernTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final Widget prefixIcon;
  final TextInputType? keyboardType;
  final Color fillColor;
  final Color labelColor;
  final Color textColor;
  final bool obscureText;

  const ModernTextField({
    Key? key,
    required this.controller,
    required this.label,
    required this.prefixIcon,
    this.keyboardType,
    required this.fillColor,
    required this.labelColor,
    required this.textColor,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: TextStyle(color: textColor, fontSize: 16),
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor,
        labelText: label,
        labelStyle: TextStyle(color: labelColor, fontWeight: FontWeight.w500),
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      ),
    );
  }
}
