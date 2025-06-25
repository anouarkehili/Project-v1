import 'package:dada_gym_app/models/admin_model.dart';
import 'package:flutter/material.dart';
import 'signup.dart';
import '../home/home_screen.dart';
import '../admin/admin_dashboard.dart';
import '../../models/user_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  void _handleLogin() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      _showErrorDialog('يرجى ملء جميع الحقول');
      return;
    }

    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2)); // محاكاة تحميل

    // تحقق تلقائي من نوع الحساب حسب الايميل والباسوورد
    if (emailController.text == 'admin@dadagym.com' && passwordController.text == '123456') {
      // دخول إداري
      // Create a dummy AdminModel for testing
      final testAdmin = AdminModel(
        id: 'admin001',
        firstName: 'انور',
        lastName: 'كحيلي',
        email: 'admin@dadagym.com',
        phone: '0699446868',
        isActive: true,
        role: 'admin',
        createdAt: DateTime.now(),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AdminDashboard(admin: testAdmin),
        ),
      );
    } else if (emailController.text == 'user@dadagym.com' && passwordController.text == '123456') {
      // دخول مشترك
      final testUser = UserModel(
        firstName: 'أحمد',
        lastName: 'محمد',
        email: 'user@dadagym.com',
        phone: '0555123456',
        isActivated: true,
        subscriptionStart: DateTime.now().subtract(const Duration(days: 5)),
        subscriptionEnd: DateTime.now().add(const Duration(days: 25)),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(user: testUser)),
      );
    } else {
      _showErrorDialog('بيانات الدخول غير صحيحة');
    }

    setState(() {
      isLoading = false;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C2E),
        title: const Text('خطأ', style: TextStyle(color: Colors.white)),
        content: Text(message, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('موافق', style: TextStyle(color: Color(0xFF00FF57))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF1C1C1E),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Hero(
                    tag: 'logo',
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00FF57).withOpacity(0.3),
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
                  
                  const Text(
                    'مرحباً بك في DADA GYM',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'سجل دخولك للمتابعة',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Email Field
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C2C2E),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextField(
                      controller: emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email, color: Color(0xFF00FF57)),
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
                      color: const Color(0xFF2C2C2E),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock, color: Color(0xFF00FF57)),
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
                        style: TextStyle(color: Color(0xFF00FF57)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00FF57),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 6,
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.black)
                          : const Text(
                              'تسجيل الدخول',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Demo credentials info
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C2C2E),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF00FF57).withOpacity(0.3)),
                    ),
                    child: const Column(
                      children: [
                        Text(
                          'بيانات تجريبية:',
                          style: TextStyle(color: Color(0xFF00FF57), fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'إداري: admin@dadagym.com\nمشترك: user@dadagym.com\nكلمة المرور: 123456',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Divider
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
                    const SizedBox(height: 16),

                    SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                      // TODO: تسجيل عبر Facebook
                      },
                      icon: const Icon(Icons.facebook, color: Color(0xFF1877F3), size: 26),
                      label: const Text(
                      'الدخول باستخدام Facebook',
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
                      backgroundColor: const Color(0xFF1C1C1E),
                      ),
                    ),
                    ),
                    const SizedBox(height: 18),

                    // Google Login Button
                    SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                      // TODO: تسجيل باستخدام Google
                      },
                      icon: const Icon(Icons.g_mobiledata, color: Color(0xFF00FF57), size: 32),
                      label: const Text(
                      'الدخول باستخدام Google',
                      style: TextStyle(
                        color: Color(0xFF00FF57),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      ),
                      style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF00FF57), width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      backgroundColor: const Color(0xFF1C1C1E),
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
                            color: Color(0xFF00FF57),
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
      ),
    );
  }
}
