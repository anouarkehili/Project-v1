import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import 'package:intl/intl.dart';

class MemberProfileScreen extends StatefulWidget {
  final UserModel user;
  
  const MemberProfileScreen({super.key, required this.user});

  @override
  State<MemberProfileScreen> createState() => _MemberProfileScreenState();
}

class _MemberProfileScreenState extends State<MemberProfileScreen> {
  bool notificationsEnabled = true;
  bool darkModeEnabled = true;

  @override
  Widget build(BuildContext context) {
    final daysRemaining = widget.user.subscriptionEnd.difference(DateTime.now()).inDays;
    final isExpired = daysRemaining < 0;
    
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: const Text('ملفي الشخصي', style: TextStyle(color: Colors.white)),
      iconTheme: const IconThemeData(color: Colors.white),
      actions: [
        IconButton(
        icon: const Icon(Icons.edit, color: Color(0xFF00FF57)),
        onPressed: () => _showEditProfileDialog(),
        ),
      ],
      ),
      body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildProfileHeader(),
        const SizedBox(height: 20),
        _buildSubscriptionCard(daysRemaining, isExpired),
        const SizedBox(height: 20),
        _buildStatsSection(),
        const SizedBox(height: 20),
        _buildSettingsSection(),
        const SizedBox(height: 20),
        _buildActionButtons(),
      ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: const Color(0xFF00FF57),
            child: Text(
              widget.user.firstName[0] + widget.user.lastName[0],
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.user.fullName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: widget.user.isActivated 
                  ? const Color(0xFF00FF57).withOpacity(0.2)
                  : Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              widget.user.isActivated ? 'عضو نشط' : 'عضو غير نشط',
              style: TextStyle(
                color: widget.user.isActivated 
                    ? const Color(0xFF00FF57)
                    : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildInfoItem('البريد الإلكتروني', widget.user.email, Icons.email),
              _buildInfoItem('رقم الهاتف', widget.user.phone, Icons.phone),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF00FF57), size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildSubscriptionCard(int daysRemaining, bool isExpired) {
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
              Icon(
                isExpired ? Icons.warning : Icons.check_circle,
                color: Colors.black,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                isExpired ? 'انتهت صلاحية الاشتراك' : 'الاشتراك نشط',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            isExpired 
                ? 'انتهت صلاحية اشتراكك منذ ${daysRemaining.abs()} يوم'
                : 'باقي $daysRemaining يوم على انتهاء الاشتراك',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDateInfo('تاريخ البداية', widget.user.subscriptionStart),
              _buildDateInfo('تاريخ الانتهاء', widget.user.subscriptionEnd),
            ],
          ),
          if (isExpired) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showRenewalDialog(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('تجديد الاشتراك'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDateInfo(String label, DateTime date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
        Text(
          DateFormat('yyyy/MM/dd').format(date),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'إحصائياتي',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildStatCard('أيام الحضور', '23', Icons.calendar_today, Colors.blue)),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard('هذا الشهر', '8', Icons.access_time, Colors.green)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildStatCard('المدة الإجمالية', '45 ساعة', Icons.timer, Colors.orange)),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard('آخر زيارة', 'أمس', Icons.last_page, Colors.purple)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
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

  Widget _buildSettingsSection() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'الإعدادات',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          _buildSwitchTile(
            'الإشعارات',
            'استقبال إشعارات التطبيق',
            notificationsEnabled,
            (value) => setState(() => notificationsEnabled = value),
            Icons.notifications,
          ),
          _buildSwitchTile(
            'الوضع المظلم',
            'استخدام الوضع المظلم',
            darkModeEnabled,
            (value) => setState(() => darkModeEnabled = value),
            Icons.dark_mode,
          ),
          _buildActionTile(
            'تغيير كلمة المرور',
            'تحديث كلمة مرور حسابك',
            Icons.lock,
            () => _showChangePasswordDialog(),
          ),
          _buildActionTile(
            'سياسة الخصوصية',
            'اطلع على سياسة الخصوصية',
            Icons.privacy_tip,
            () {
              // TODO: عرض سياسة الخصوصية
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, Function(bool) onChanged, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF00FF57)),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF00FF57),
      ),
    );
  }

  Widget _buildActionTile(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF00FF57)),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _showQRCode(),
            icon: const Icon(Icons.qr_code, color: Colors.black),
            label: const Text('عرض QR الخاص بي', style: TextStyle(color: Colors.black)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00FF57),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _showLogoutDialog(),
            icon: const Icon(Icons.logout, color: Colors.red),
            label: const Text('تسجيل الخروج', style: TextStyle(color: Colors.red)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.red),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showEditProfileDialog() {
    final firstNameController = TextEditingController(text: widget.user.firstName);
    final lastNameController = TextEditingController(text: widget.user.lastName);
    final phoneController = TextEditingController(text: widget.user.phone);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C2E),
        title: const Text('تعديل الملف الشخصي', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: firstNameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'الاسم الأول',
                labelStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: lastNameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'الاسم العائلي',
                labelStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'رقم الهاتف',
                labelStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم حفظ التغييرات بنجاح')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00FF57)),
            child: const Text('حفظ', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  void _showRenewalDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C2E),
        title: const Text('تجديد الاشتراك', style: TextStyle(color: Colors.white)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('اختر نوع الاشتراك:', style: TextStyle(color: Colors.white)),
            SizedBox(height: 16),
            ListTile(
              title: Text('اشتراك شهري - 3000 دج', style: TextStyle(color: Colors.white)),
              leading: Radio(value: 1, groupValue: 1, onChanged: null),
            ),
            ListTile(
              title: Text('اشتراك 3 أشهر - 8000 دج', style: TextStyle(color: Colors.white)),
              leading: Radio(value: 2, groupValue: 1, onChanged: null),
            ),
            ListTile(
              title: Text('اشتراك سنوي - 30000 دج', style: TextStyle(color: Colors.white)),
              leading: Radio(value: 3, groupValue: 1, onChanged: null),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم إرسال طلب التجديد بنجاح')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00FF57)),
            child: const Text('تجديد', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  void _showQRCode() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C2E),
        title: const Text('QR الخاص بك', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(Icons.qr_code, size: 150, color: Colors.black),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'اعرض هذا الرمز للموظف عند الدخول',
              style: TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00FF57)),
            child: const Text('إغلاق', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C2E),
        title: const Text('تغيير كلمة المرور', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'كلمة المرور الحالية',
                labelStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'كلمة المرور الجديدة',
                labelStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'تأكيد كلمة المرور الجديدة',
                labelStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم تغيير كلمة المرور بنجاح')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00FF57)),
            child: const Text('حفظ', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C2E),
        title: const Text('تسجيل الخروج', style: TextStyle(color: Colors.white)),
        content: const Text('هل أنت متأكد من تسجيل الخروج؟', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('تسجيل الخروج', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}