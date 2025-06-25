import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../models/user_model.dart';
import '../../services/user_service.dart';
import '../../services/attendance_service.dart';
import 'subscribers_list_screen.dart';
import 'attendance_screen.dart';
import 'statistics_screen.dart';
import 'admin_settings_screen.dart';
import 'qr_management_screen.dart';

class AdminDashboard extends StatefulWidget {
  final UserModel admin;
  
  const AdminDashboard({super.key, required this.admin});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final UserService _userService = UserService();
  final AttendanceService _attendanceService = AttendanceService();
  
  Map<String, int> userStats = {};
  Map<String, int> attendanceStats = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final userStatsData = await _userService.getUserStats();
      final attendanceStatsData = await _attendanceService.getAttendanceStats();
      
      setState(() {
        userStats = userStatsData;
        attendanceStats = attendanceStatsData;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF1C1C1E),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'لوحة تحكم الإدارة',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'مرحباً ${widget.admin.firstName}',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(left: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00FF57).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.admin.roleDisplayName,
                      style: const TextStyle(
                        color: Color(0xFF00FF57),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Color(0xFF00FF57)),
                    onPressed: _loadStats,
                  ),
                ],
              ),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _loadStats,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildWelcomeCard(),
              const SizedBox(height: 20),
              if (isLoading)
                const Center(child: CircularProgressIndicator(color: Color(0xFF00FF57)))
              else
                _buildQuickStats(),
              const SizedBox(height: 20),
              const Text(
                'الإدارة والتحكم',
                style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildAdminGrid(context),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xFF2C2C2E),
          selectedItemColor: const Color(0xFF00FF57),
          unselectedItemColor: Colors.white60,
          currentIndex: 0,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'الرئيسية'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'المشتركين'),
            BottomNavigationBarItem(icon: Icon(Icons.access_time), label: 'الحضور'),
            BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: 'QR'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'الإعدادات'),
          ],
          onTap: (index) {
            switch (index) {
              case 1:
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SubscribersListScreen()));
                break;
              case 2:
                Navigator.push(context, MaterialPageRoute(builder: (_) => const AttendanceScreen()));
                break;
              case 3:
                Navigator.push(context, MaterialPageRoute(builder: (_) => const QRManagementScreen()));
                break;
              case 4:
                Navigator.push(context, MaterialPageRoute(builder: (_) => AdminSettingsScreen(admin: widget.admin)));
                break;
            }
          },
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00FF57), Color(0xFF00CC45)],
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.admin_panel_settings, size: 30, color: Colors.black),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مرحباً ${widget.admin.fullName}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    Text(
                      widget.admin.roleDisplayName,
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Text(
            'إدارة شاملة لصالة DADA GYM',
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              _buildQuickStatItem('المشتركين النشطين', userStats['active']?.toString() ?? '0'),
              const SizedBox(width: 20),
              _buildQuickStatItem('الحضور اليوم', attendanceStats['today']?.toString() ?? '0'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.black54)),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
      ],
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard('إجمالي المشتركين', userStats['total']?.toString() ?? '0', Icons.people, Colors.blue),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard('الحضور اليوم', attendanceStats['today']?.toString() ?? '0', Icons.access_time, Colors.green),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard('غير المفعلين', userStats['inactive']?.toString() ?? '0', Icons.pending, Colors.orange),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAdminGrid(BuildContext context) {
    final adminFeatures = [
      {
        'title': 'إدارة المشتركين',
        'icon': Icons.people_alt,
        'color': Colors.blue,
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SubscribersListScreen())),
      },
      {
        'title': 'سجل الحضور',
        'icon': Icons.access_time,
        'color': Colors.green,
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AttendanceScreen())),
      },
      {
        'title': 'إدارة QR',
        'icon': Icons.qr_code,
        'color': Colors.purple,
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QRManagementScreen())),
      },
      {
        'title': 'الإحصائيات',
        'icon': Icons.bar_chart,
        'color': Colors.teal,
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StatisticsScreen())),
      },
      {
        'title': 'الإعدادات',
        'icon': Icons.settings,
        'color': Colors.grey,
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => AdminSettingsScreen(admin: widget.admin))),
      },
      {
        'title': 'التقارير',
        'icon': Icons.assessment,
        'color': Colors.orange,
        'onTap': () {
          // TODO: صفحة التقارير
        },
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: adminFeatures.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemBuilder: (context, index) {
        final feature = adminFeatures[index];
        return GestureDetector(
          onTap: feature['onTap'] as VoidCallback,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF2C2C2E),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: (feature['color'] as Color).withOpacity(0.3), width: 1),
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
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}