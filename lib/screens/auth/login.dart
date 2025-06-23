import 'package:flutter/material.dart';
import 'signup.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFF181829),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                color: Colors.deepPurple.withOpacity(0.3),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
              ),
              child: Image.asset(
            'assets/images/logo.png',
            height: 120,
              ),
            ),
          ),
            ),
            const SizedBox(height: 32),
                const SizedBox(height: 32),
                // Email Field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    controller: emailController,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email, color: Colors.deepPurpleAccent),
                      labelText: 'البريد الإلكتروني',
                      labelStyle: const TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                // Password Field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock, color: Colors.deepPurpleAccent),
                      labelText: 'كلمة المرور',
                      labelStyle: const TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Forgot Password
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      // TODO: Forgot password action
                    },
                    child: const Text(
                      'نسيت كلمة المرور؟',
                      style: TextStyle(color: Colors.deepPurpleAccent),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: تحقق من بيانات الدخول
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 6,
                      shadowColor: Colors.deepPurpleAccent.withOpacity(0.3),
                    ),
                    child: const Text(
                      'تسجيل الدخول',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                // Divider with text
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.white24,
                        thickness: 1,
                        endIndent: 8,
                      ),
                    ),
                    const Text(
                      'أو',
                      style: TextStyle(color: Colors.white54),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.white24,
                        thickness: 1,
                        indent: 8,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                // QR Login Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: تسجيل باستخدام QR
                    },
                    icon: const Icon(Icons.qr_code_scanner, color: Colors.deepPurpleAccent),
                    label: const Text(
                      'تسجيل الدخول باستخدام QR',
                      style: TextStyle(color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.deepPurpleAccent, width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Signup
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'ليس لديك حساب؟',
                      style: TextStyle(color: Colors.white70),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SignupScreen()),
                        );
                      },
                      child: const Text(
                        'إنشاء حساب جديد',
                        style: TextStyle(
                          color: Colors.deepPurpleAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
