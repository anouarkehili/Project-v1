import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../models/user_model.dart';
import '../../services/attendance_service.dart';
import '../member/member_profile_screen.dart';
import 'qr_scanner_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  final UserModel user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final AttendanceService _attendanceService = AttendanceService();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF1C1C1E),
        body: IndexedStack(
          index: _currentIndex,
          children: [
            _buildHomeTab(),
            _buildAttendanceTab(),
            _buildWorkoutsTab(),
            MemberProfileScreen(user: widget.user),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xFF2C2C2E),
          selectedItemColor: const Color(0xFF00FF57),
          unselectedItemColor: Colors.white60,
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
            BottomNavigationBarItem(icon: Icon(Icons.access_time), label: 'الحضور'),
            BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label:  'التمارين'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'حسابي'),
          ],
        ),
        floatingActionButton: _currentIndex == 1 ? FloatingActionButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => QRScannerScreen(user: widget.user),
            ),
          ),
          backgroundColor: const Color(0xFF00FF57),
          child: const Icon(Icons.qr_code_scanner, color: Colors.black),
        ) : null,
      ),
    );
  }

  Widget _buildHomeTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 40),
        _buildSubscriptionCard(widget.user),
        const SizedBox(height: 20),
        const Text(
          'القائمة الرئيسية',
          style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        _buildFeatureGrid(context),
      ],
    );
  }

  Widget _buildAttendanceTab() {
    return AttendanceScreen(user: widget.user);
  }

  Widget _buildWorkoutsTab() {
    return const WorkoutsScreen();
  }

  Widget _buildSubscriptionCard(UserModel user) {
    final daysRemaining = user.daysRemaining;
    final isExpired = !user.isSubscriptionActive;
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isExpired 
              ? [Colors.red.shade400, Colors.red.shade600]
              : [const Color(0xFF00FF57), const Color(0xFF00CC45)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.2),
                child: Text(
                  user.firstName[0],
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مرحبًا، ${user.firstName}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    Text(
                      isExpired ? 'انتهت صلاحية الاشتراك' : 'عضو نشط',
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'حالة الاشتراك',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isExpired 
                    ? '❌ منتهي الصلاحية'
                    : '✅ نشط ($daysRemaining يوم متبقي)',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ],
          ),
          if (user.subscriptionStart != null && user.subscriptionEnd != null) ...[
            const SizedBox(height: 8),
            Text(
              'من ${_formatDate(user.subscriptionStart!)} إلى ${_formatDate(user.subscriptionEnd!)}',
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFeatureGrid(BuildContext context) {
    final features = [
      {
        'title': 'تسجيل الحضور',
        'icon': Icons.qr_code_scanner,
        'color': Colors.blue,
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => QRScannerScreen(user: widget.user),
          ),
        ),
      },
      {
        'title': 'مكتبة التمارين',
        'icon': Icons.fitness_center,
        'color': Colors.orange,
        'onTap': () => setState(() => _currentIndex = 2),
      },
      {
        'title': 'سجل الحضور',
        'icon': Icons.access_time,
        'color': Colors.green,
        'onTap': () => setState(() => _currentIndex = 1),
      },
      {
        'title': 'ملفي الشخصي',
        'icon': Icons.person,
        'color': Colors.purple,
        'onTap': () => setState(() => _currentIndex = 3),
      },
      {
        'title': 'الدعم الفني',
        'icon': Icons.support_agent,
        'color': Colors.teal,
        'onTap': () => _showSupportDialog(),
      },
      {
        'title': 'حول التطبيق',
        'icon': Icons.info_outline,
        'color': Colors.pink,
        'onTap': () => _showAboutDialog(),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: features.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemBuilder: (context, index) {
        final feature = features[index];
        return GestureDetector(
          onTap: feature['onTap'] as VoidCallback,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF2C2C2E),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: (feature['color'] as Color).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (feature['color'] as Color).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    feature['icon'] as IconData,
                    color: feature['color'] as Color,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  feature['title'] as String,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSupportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C2E),
        title: const Text('الدعم الفني', style: TextStyle(color: Colors.white)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'كيف يمكننا مساعدتك؟',
              style: TextStyle(color: Colors.white70),
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.phone, color: Color(0xFF00FF57)),
              title: Text('اتصل بنا', style: TextStyle(color: Colors.white)),
              subtitle: Text('0699446868', style: TextStyle(color: Colors.white70)),
            ),
            ListTile(
              leading: Icon(Icons.email, color: Color(0xFF00FF57)),
              title: Text('راسلنا', style: TextStyle(color: Colors.white)),
              subtitle: Text('support@dadagym.com', style: TextStyle(color: Colors.white70)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              launchUrl(Uri.parse("https://wa.me/213699446868"));
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00FF57)),
            child: const Text('واتساب', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1C1C1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Column(
                  children: [
                    Icon(Icons.fitness_center, color: Color(0xFF00FF57), size: 40),
                    SizedBox(height: 8),
                    Text(
                      'تطبيق DADA GYM',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'الإصدار 1.0.0',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'تطبيق خاص بصالة DADA GYM يتيح لك:',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                '✅ تسجيل الحضور عبر QR Code.\n✅ الوصول إلى مكتبة التمارين.\n✅ متابعة حالة الاشتراك.\n✅ دعم فني مباشر.',
                style: TextStyle(color: Colors.white70, fontSize: 15),
              ),
              const SizedBox(height: 24),
              const Text(
                'مطور التطبيق:',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const Text(
                'ANOUAR KEHILI',
                style: TextStyle(color: Color(0xFF00FF57), fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    launchUrl(Uri.parse("https://wa.me/213699446868"));
                  },
                  icon: const FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white, size: 20),
                  label: const Text(
                    'التواصل مع المطور عبر واتساب',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  label: const Text('إغلاق'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00FF57),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month}/${date.day}';
  }
}

// صفحة سجل الحضور
class AttendanceScreen extends StatelessWidget {
  final UserModel user;
  
  const AttendanceScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سجل الحضور', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: const Color(0xFF1C1C1E),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTodayStatus(),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                'سجل الحضور:',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(child: _buildAttendanceList()),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayStatus() {
    return FutureBuilder<bool>(
      future: AttendanceService().hasAttendedToday(user.uid),
      builder: (context, snapshot) {
        bool hasAttended = snapshot.data ?? false;
        
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: hasAttended 
                ? Colors.green.withOpacity(0.2)
                : Colors.orange.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasAttended ? Colors.green : Colors.orange,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                hasAttended ? Icons.check_circle : Icons.pending,
                color: hasAttended ? Colors.green : Colors.orange,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  hasAttended 
                      ? 'تم تسجيل حضورك اليوم'
                      : 'لم يتم تسجيل حضورك اليوم بعد',
                  style: TextStyle(
                    color: hasAttended ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (!hasAttended)
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QRScannerScreen(user: user),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00FF57),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'تسجيل الحضور',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttendanceList() {
    return StreamBuilder(
      stream: AttendanceService().getUserAttendance(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF00FF57)),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'لا يوجد سجل حضور',
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final attendance = snapshot.data![index];
            return Card(
              color: const Color(0xFF2C2C2E),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                leading: const Icon(Icons.check_circle, color: Color(0xFF00FF57), size: 28),
                title: Text(
                  _formatDate(attendance.date),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: Row(
                  children: [
                    const Icon(Icons.access_time, color: Colors.white54, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      _formatTime(attendance.checkInTime),
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
                trailing: const Text(
                  'حضر',
                  style: TextStyle(
                    color: Color(0xFF00FF57),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

// صفحة التمارين
class WorkoutsScreen extends StatelessWidget {
  const WorkoutsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final workoutCategories = [
      {
        'title': 'تمارين الصدر',
        'icon': Icons.fitness_center,
        'color': Colors.red,
        'exercises': ['ضغط البنش', 'ضغط مائل', 'فتح دمبل', 'ديبس'],
      },
      {
        'title': 'تمارين الظهر',
        'icon': Icons.accessibility_new,
        'color': Colors.blue,
        'exercises': ['سحب علوي', 'سحب أرضي', 'ديد ليفت', 'شراع'],
      },
      {
        'title': 'تمارين الأرجل',
        'icon': Icons.directions_run,
        'color': Colors.green,
        'exercises': ['سكوات', 'لانجز', 'ليج بريس', 'كالف'],
      },
      {
        'title': 'تمارين الكتف',
        'icon': Icons.sports_gymnastics,
        'color': Colors.orange,
        'exercises': ['ضغط كتف', 'رفرفة جانبي', 'رفرفة خلفي', 'شراج'],
      },
      {
        'title': 'تمارين البطن',
        'icon': Icons.self_improvement,
        'color': Colors.purple,
        'exercises': ['كرانش', 'بلانك', 'رفع أرجل', 'روسيان تويست'],
      },
      {
        'title': 'تمارين الذراع',
        'icon': Icons.sports_handball,
        'color': Colors.teal,
        'exercises': ['بايسبس كيرل', 'ترايسبس', 'هامر كيرل', 'ديبس'],
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        title: const Text('مكتبة التمارين', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'اختر مجموعة التمارين:',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                itemCount: workoutCategories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.1,
                ),
                itemBuilder: (context, index) {
                  final category = workoutCategories[index];
                  return GestureDetector(
                    onTap: () => _showExercises(context, category),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C2C2E),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: (category['color'] as Color).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: (category['color'] as Color).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              category['icon'] as IconData,
                              color: category['color'] as Color,
                              size: 30,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            category['title'] as String,
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${(category['exercises'] as List).length} تمارين',
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
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

  void _showExercises(BuildContext context, Map<String, dynamic> category) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2C2C2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (category['color'] as Color).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    category['icon'] as IconData,
                    color: category['color'] as Color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  category['title'] as String,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...((category['exercises'] as List<String>).map((exercise) => 
              ListTile(
                leading: const Icon(Icons.play_circle_outline, color: Color(0xFF00FF57)),
                title: Text(exercise, style: const TextStyle(color: Colors.white)),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
                onTap: () {
                  Navigator.pop(context);
                  _showExerciseDetails(context, exercise);
                },
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }

  void _showExerciseDetails(BuildContext context, String exercise) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C2E),
        title: Text(exercise, style: const TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 200,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(Icons.play_circle_outline, size: 60, color: Color(0xFF00FF57)),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'شرح التمرين وطريقة الأداء الصحيحة',
              style: TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              '• 3 مجموعات\n• 12-15 تكرار\n• راحة 60 ثانية',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00FF57)),
            child: const Text('بدء التمرين', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}