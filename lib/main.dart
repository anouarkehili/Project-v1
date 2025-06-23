import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/home/home_screen.dart';
import 'models/user_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final testUser = UserModel(
      firstName: 'أنور',
      lastName: 'كحيلي',
      email: 'anouar@example.com',
      phone: '0555123456',
      isActivated: true,
      subscriptionStart: DateTime(2025, 6, 1),
      subscriptionEnd: DateTime(2025, 7, 1),
    );

    return MaterialApp(
      title: 'DADA GYM',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Arial',
      ),

      // 🔁 تفعيل RTL تلقائيًا
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },

      locale: const Locale('ar', 'DZ'),
      supportedLocales: const [
        Locale('ar', 'DZ'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      home: HomeScreen(user: testUser),
    );
  }
}
