import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // الحصول على المستخدم الحالي
  User? get currentUser => _auth.currentUser;

  // تدفق حالة المصادقة
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // تسجيل الدخول
  Future<UserModel?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        // تحديث آخر تسجيل دخول
        await _firestore.collection('users').doc(result.user!.uid).update({
          'lastLogin': FieldValue.serverTimestamp(),
        });

        return await getUserData(result.user!.uid);
      }
      return null;
    } catch (e) {
      throw Exception('خطأ في تسجيل الدخول: ${e.toString()}');
    }
  }

  // تسجيل مستخدم جديد
  Future<UserModel?> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        // إنشاء بيانات المستخدم في Firestore
        UserModel newUser = UserModel(
          uid: result.user!.uid,
          firstName: firstName,
          lastName: lastName,
          email: email,
          phone: phone,
          role: UserRole.user,
          isActivated: false, // غير مفعل افتراضياً
          createdAt: DateTime.now(),
        );

        await _firestore.collection('users').doc(result.user!.uid).set(newUser.toFirestore());

        return newUser;
      }
      return null;
    } catch (e) {
      throw Exception('خطأ في إنشاء الحساب: ${e.toString()}');
    }
  }

  // الحصول على بيانات المستخدم
  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('خطأ في جلب بيانات المستخدم: ${e.toString()}');
    }
  }

  // تسجيل الخروج
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('خطأ في تسجيل الخروج: ${e.toString()}');
    }
  }

  // تحديث بيانات المستخدم
  Future<void> updateUserData(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(uid).update(data);
    } catch (e) {
      throw Exception('خطأ في تحديث البيانات: ${e.toString()}');
    }
  }

  // تغيير كلمة المرور
  Future<void> changePassword(String newPassword) async {
    try {
      await _auth.currentUser?.updatePassword(newPassword);
    } catch (e) {
      throw Exception('خطأ في تغيير كلمة المرور: ${e.toString()}');
    }
  }

  // إعادة تعيين كلمة المرور
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('خطأ في إرسال رابط إعادة التعيين: ${e.toString()}');
    }
  }
}