// lib/models/user_model.dart

class UserModel {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final bool isActivated;
  final DateTime subscriptionStart;
  final DateTime subscriptionEnd;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.isActivated,
    required this.subscriptionStart,
    required this.subscriptionEnd,
  });

  String get fullName => '$firstName $lastName';
}
