import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // أضف هذا السطر

  void _handleSignup() async {
    if (_validateForm()) {
      setState(() {
        isLoading = true;
      });

      try {
        // إنشاء مستخدم جديد في Firebase Auth
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text,
        );

        // تحديث اسم المستخدم (اختياري)
        await userCredential.user?.updateDisplayName(
          '${firstNameController.text.trim()} ${lastNameController.text.trim()}',
        );

        // حفظ بيانات المستخدم في Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'firstName': firstNameController.text.trim(),
          'lastName': lastNameController.text.trim(),
          'phone': phoneController.text.trim(),
          'email': emailController.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        });

        setState(() {
          isLoading = false;
        });

        _showSuccessDialog();
      } on FirebaseAuthException catch (e) {
        setState(() {
          isLoading = false;
        });
        String errorMessage = 'حدث خطأ أثناء إنشاء الحساب';
        if (e.code == 'email-already-in-use') {
          errorMessage = 'البريد الإلكتروني مستخدم بالفعل';
        } else if (e.code == 'weak-password') {
          errorMessage = 'كلمة المرور ضعيفة جداً';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'البريد الإلكتروني غير صالح';
        }
        _showErrorDialog(errorMessage);
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        _showErrorDialog('حدث خطأ غير متوقع');
      }
    }
  }

  bool _validateForm() {
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      _showErrorDialog('يرجى ملء جميع الحقول');
      return false;
    }

    if (!emailController.text.contains('@')) {
      _showErrorDialog('يرجى إدخال بريد إلكتروني صحيح');
      return false;
    }

    if (passwordController.text.length < 6) {
      _showErrorDialog('كلمة المرور يجب أن تكون 6 أحرف على الأقل');
      return false;
    }

    return true;
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

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C2E),
        title: const Text('تم بنجاح', style: TextStyle(color: Colors.white)),
        content: const Text(
          'تم إنشاء حسابك بنجاح. سيتم مراجعة طلبك وتفعيل الحساب قريباً.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
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
        body: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 420),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    color: const Color(0xFF2C2C2E),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // زر الرجوع
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF00FF57), size: 26),
                                onPressed: () => Navigator.pop(context),
                                tooltip: 'رجوع',
                              ),
                              const Spacer(),
                            ],
                          ),

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
                              color: Color(0xFF00FF57),
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 20),

                          ModernTextField(
                            controller: firstNameController,
                            label: 'الاسم الأول',
                            prefixIcon: const Icon(Icons.person, color: Color(0xFF00FF57)),
                          ),
                          const SizedBox(height: 12),

                          ModernTextField(
                            controller: lastNameController,
                            label: 'الاسم العائلي',
                            prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF00FF57)),
                          ),
                          const SizedBox(height: 12),

                          ModernTextField(
                            controller: phoneController,
                            label: 'رقم الهاتف',
                            prefixIcon: const Icon(Icons.phone, color: Color(0xFF00FF57)),
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 12),

                          ModernTextField(
                            controller: emailController,
                            label: 'البريد الإلكتروني',
                            prefixIcon: const Icon(Icons.email, color: Color(0xFF00FF57)),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 12),

                          ModernTextField(
                            controller: passwordController,
                            label: 'كلمة المرور',
                            prefixIcon: const Icon(Icons.lock, color: Color(0xFF00FF57)),
                            obscureText: true,
                          ),
                          const SizedBox(height: 22),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : _handleSignup,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00FF57),
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                elevation: 4,
                              ),
                              child: isLoading
                                  ? const CircularProgressIndicator(color: Colors.black)
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.check_circle_outline, size: 22, color: Colors.black),
                                        SizedBox(width: 10),
                                        Text(
                                          'تسجيل',
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
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
                          const SizedBox(height: 10),

                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'لديك حساب بالفعل؟ تسجيل الدخول',
                              style: TextStyle(
                                color: Color(0xFF00FF57),
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
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.4),
                child: const Center(
                  child: CircularProgressIndicator(color: Color(0xFF00FF57)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ModernTextField widget definition
class ModernTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;

  const ModernTextField({
    Key? key,
    required this.controller,
    required this.label,
    this.prefixIcon,
    this.keyboardType,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white70, fontSize: 16),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF1C1C1E),
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        labelStyle: const TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.w500,
        ),
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
