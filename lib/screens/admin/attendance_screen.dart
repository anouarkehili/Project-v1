// lib/screens/admin/attendance_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  DateTime selectedDate = DateTime.now();
  List<Map<String, String>> attendanceList = []; // Temporary dummy data (مؤقتًا بيانات وهمية)

  @override
  void initState() {
    super.initState();
    loadAttendanceForDate(selectedDate);
  }

  void loadAttendanceForDate(DateTime date) {
    // ❗ لاحقًا سيتم جلب البيانات من قاعدة البيانات
    setState(() {
      // أمثلة على بيانات حضور
      attendanceList = [
        {'name': 'أنور كحيلي', 'time': '08:32'},
        {'name': 'أحمد زيد', 'time': '10:15'},
        {'name': 'سارة منصور', 'time': '11:00'},
      ];
    });
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
      locale: const Locale('ar', 'DZ'),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      loadAttendanceForDate(selectedDate);
    }
  }
@override
Widget build(BuildContext context) {
  final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

  return Scaffold(
    appBar: AppBar(
      title: const Text('سجل الحضور'),
      actions: [
        IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: _pickDate,
        ),
      ],
    ),
    body: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          alignment: Alignment.center,
          child: Text(
            '📅 الحضور ليوم: $formattedDate',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: attendanceList.isEmpty
              ? const Center(
                  child: Text('لا يوجد حضور لهذا اليوم.'),
                )
              : ListView.builder(
                  itemCount: attendanceList.length,
                  itemBuilder: (context, index) {
                    final item = attendanceList[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        leading: const Icon(Icons.person, color: Colors.green),
                        title: Text(item['name']!),
                        subtitle: Text('🕒 ${item['time']}'),
                      ),
                    );
                  },
                ),
        ),
      ],
    ),
  );
}

}
