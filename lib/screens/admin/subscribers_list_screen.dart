// lib/screens/admin/subscribers_list_screen.dart

import 'package:flutter/material.dart';
import '../../../models/user_model.dart'; // تأكد من وجوده وتحديثه عند الحاجة

class SubscribersListScreen extends StatefulWidget {
  const SubscribersListScreen({super.key});

  @override
  State<SubscribersListScreen> createState() => _SubscribersListScreenState();
}

class _SubscribersListScreenState extends State<SubscribersListScreen> {
  List<UserModel> allUsers = []; // بيانات المشتركين
  List<UserModel> filteredUsers = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  void loadUsers() {
    // مؤقتًا: بيانات وهمية (يجب ربطها مع قاعدة بيانات لاحقًا)
    allUsers = [
      UserModel(
        firstName: 'أنور',
        lastName: 'كحيلي',
        email: 'anouar@example.com',
        phone: '0555123456',
        isActivated: false,
        subscriptionStart: DateTime.now(),
        subscriptionEnd: DateTime.now().add(const Duration(days: 0)),
      ),
      UserModel(
        firstName: 'أحمد',
        lastName: 'زيد',
        email: 'ahmed@example.com',
        phone: '0777988888',
        isActivated: true,
        subscriptionStart: DateTime.now().subtract(const Duration(days: 3)),
        subscriptionEnd: DateTime.now().add(const Duration(days: 27)),
      ),
    ];

    filteredUsers = allUsers;
  }

  void handleSearch(String value) {
    setState(() {
      searchQuery = value;
      filteredUsers = allUsers
          .where((user) =>
              user.fullName.contains(value) ||
              user.email.contains(value) ||
              user.phone.contains(value))
          .toList();
    });
  }

  void activateUser(UserModel user, int days) {
    setState(() {
      final updatedUser = UserModel(
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
        phone: user.phone,
        isActivated: true,
        subscriptionStart: DateTime.now(),
        subscriptionEnd: DateTime.now().add(Duration(days: days)),
      );
      final index = allUsers.indexOf(user);
      if (index != -1) {
        allUsers[index] = updatedUser;
      }
      filteredUsers = allUsers
          .where((user) =>
              user.fullName.contains(searchQuery) ||
              user.email.contains(searchQuery) ||
              user.phone.contains(searchQuery))
          .toList();
    });

    // هنا يتم حفظ التغيير في قاعدة البيانات لاحقًا
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إدارة المشتركين'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'ابحث باسم أو رقم هاتف',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: handleSearch,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = filteredUsers[index];
                  final isExpired = user.subscriptionEnd.isBefore(DateTime.now());

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.fullName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('📧 ${user.email}'),
                          Text('📱 ${user.phone}'),
                          Text(
                            '🕒 الاشتراك: ${user.subscriptionStart.toLocal().toString().split(' ')[0]} - ${user.subscriptionEnd.toLocal().toString().split(' ')[0]}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                user.isActivated
                                    ? (isExpired ? '❌ منتهي' : '✅ مفعل')
                                    : '⏳ غير مفعل',
                                style: TextStyle(
                                  color: user.isActivated
                                      ? (isExpired ? Colors.red : Colors.green)
                                      : Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              if (!user.isActivated || isExpired)
                                ElevatedButton(
                                  onPressed: () async {
                                    int days = await showDialog(
                                          context: context,
                                          builder: (context) => _SubscriptionDialog(),
                                        ) ?? 30;
                                    activateUser(user, days);
                                  },
                                  child: const Text('تفعيل'),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubscriptionDialog extends StatefulWidget {
  @override
  State<_SubscriptionDialog> createState() => _SubscriptionDialogState();
}

class _SubscriptionDialogState extends State<_SubscriptionDialog> {
  int days = 30;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('مدة الاشتراك'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('اختر عدد أيام الاشتراك:'),
          Slider(
            min: 1,
            max: 90,
            divisions: 89,
            value: days.toDouble(),
            label: '$days يوم',
            onChanged: (value) {
              setState(() {
                days = value.toInt();
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, days),
          child: const Text('تأكيد'),
        ),
      ],
    );
  }
}
