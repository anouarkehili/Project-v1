import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../../models/user_model.dart';
import 'package:url_launcher/url_launcher.dart';
import '../admin/admin_dashboard.dart';

class HomeScreen extends StatelessWidget {
  final UserModel user;
  const HomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: null,
      ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSubscriptionCard(user),
            const SizedBox(height: 20),
            const Text(
              'القائمة الرئيسية',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(height: 10),
            _buildFeatureGrid(context),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // TODO: عرض QR الخاص بالمشترك
          },
          backgroundColor: const Color(0xFF00FF57),
          child: const Icon(Icons.qr_code, color: Colors.black),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.grey[900],
          selectedItemColor: const Color(0xFF00FF57),
          unselectedItemColor: Colors.white60,
          currentIndex: 0,
          onTap: (index) {
            // TODO: الانتقال بين الصفحات
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
            BottomNavigationBarItem(icon: Icon(Icons.access_time), label: 'الحضور'),
            BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'التمارين'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'حسابي'),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionCard(UserModel user) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF00FF57),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'مرحبًا، ${user.firstName}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'حالة الاشتراك',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                user.isActivated ? '✅ مفعل' : '⛔ غير مفعل',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                'من ${_formatDate(user.subscriptionStart)} إلى ${_formatDate(user.subscriptionEnd)}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureGrid(BuildContext context) {
    final features = [
      {
      'title': 'الدخول للصالة',
      'icon': Icons.door_front_door,
      'onTap': () {
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AttendanceScreen()),
        );
      }
      },
      {
      'title': 'مكتبة التمارين',
      'icon': Icons.fitness_center,
      'onTap': () {},
      },
      {
      'title': 'الدعم الفني',
      'icon': Icons.support_agent,
      'onTap': () {},
      },
      {
      'title': 'ملفي الشخصي',
      'icon': Icons.person,
      'onTap': () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdminDashboard()),
        );
      },
      },
      {
      'title': 'مواقع التواصل',
      'icon': Icons.share,
      'onTap': () {
        showModalBottomSheet(
          context: context,
          backgroundColor: const Color(0xFF2C2C2E),
          shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('تابعنا على مواقع التواصل', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(FontAwesomeIcons.facebook, color: Color(0xFF00FF57), size: 32),
              onPressed: () {
            // ضع هنا رابط الفايسبوك الخاص بك
            // مثال:
            // launchUrl(Uri.parse('https://facebook.com/yourpage'));
              },
            ),
            IconButton(
              icon: const Icon(FontAwesomeIcons.tiktok, color: Color(0xFF00FF57), size: 32), // تيك توك
              onPressed: () {
            // ضع هنا رابط التيك توك الخاص بك
            // launchUrl(Uri.parse('https://tiktok.com/@yourusername'));
              },
            ),
            IconButton(
              icon: const Icon(FontAwesomeIcons.instagram, color: Color(0xFF00FF57), size: 32), // انستغرام
              onPressed: () {
            // ضع هنا رابط الانستغرام الخاص بك
            // launchUrl(Uri.parse('https://instagram.com/yourusername'));
              },
            ),
            IconButton(
              icon: const Icon(FontAwesomeIcons.whatsapp, color: Color(0xFF00FF57), size: 32),
              onPressed: () {
            // ضع هنا رابط الواتساب الخاص بك
            // launchUrl(Uri.parse('https://wa.me/213XXXXXXXXX'));
              },
            ),
          ],
            ),
          ],
        ),
          ),
        );
      },
      },
      
{
  'title': 'حول التطبيق',
  'icon': Icons.info_outline,
  'onTap': () {
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
              Center(
                child: Column(
                  children: const [
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
                '✅ تسجيل الدخول وتتبع الحضور.\n✅ الوصول إلى مكتبة التمارين.\n✅ دعم فني مباشر.',
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
  },
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
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  feature['icon'] as IconData,
                  color: const Color(0xFF00FF57),
                  size: 30,
                ),
                const SizedBox(height: 10),
                Text(
                  feature['title'] as String,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month}/${date.day}';
  }
}

// صفحة سجل الحضور وتسجيل الدخول
class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // بيانات سجل الحضور التجريبية مع الوقت
    final attendanceList = [
      {'date': '2024/06/01', 'time': '08:30', 'status': 'present'},
      {'date': '2024/05/31', 'time': '09:10', 'status': 'present'},
      {'date': '2024/05/30', 'time': '—', 'status': 'absent'},
    ];

    Icon _statusIcon(String status) {
      if (status == 'present') {
        return const Icon(Icons.check_circle, color: Color(0xFF00FF57), size: 28);
      } else {
        return const Icon(Icons.cancel, color: Colors.redAccent, size: 28);
      }
    }

    String _statusText(String status) {
      return status == 'present' ? 'حضر' : 'غائب';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('سجل الحضور', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      backgroundColor: const Color(0xFF1C1C1E),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: قراءة QR
                    },
                    icon: const Icon(Icons.qr_code_scanner, color: Colors.black),
                    label: const Text('قراءة QR', style: TextStyle(color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00FF57),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: عرض QR الخاص بالمستخدم
                    },
                    icon: const Icon(Icons.qr_code, color: Colors.black),
                    label: const Text('عرض QR', style: TextStyle(color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00FF57),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                'سجل الأيام:',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: attendanceList.length,
                itemBuilder: (context, index) {
                  final item = attendanceList[index];
                  return Card(
                    color: const Color(0xFF2C2C2E),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: _statusIcon(item['status']!),
                      title: Text(
                        item['date']!,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Row(
                        children: [
                          const Icon(Icons.access_time, color: Colors.white54, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            item['time']!,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                      trailing: Text(
                        _statusText(item['status']!),
                        style: TextStyle(
                          color: item['status'] == 'present' ? const Color(0xFF00FF57) : Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
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
