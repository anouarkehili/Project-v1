import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:dada_gym_app/main.dart';

class SupportMessagesScreen extends StatefulWidget {
  const SupportMessagesScreen({super.key});

  @override
  State<SupportMessagesScreen> createState() => _SupportMessagesScreenState();
}

class _SupportMessagesScreenState extends State<SupportMessagesScreen> {
  List<Map<String, dynamic>> conversations = [
    {
      'id': '1',
      'userName': 'أحمد محمد',
      'lastMessage': 'مرحباً، أريد الاستفسار عن أوقات العمل',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 30)),
      'unreadCount': 2,
      'isOnline': true,
    },
    {
      'id': '2',
      'userName': 'سارة أحمد',
      'lastMessage': 'شكراً لكم على المساعدة',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'unreadCount': 0,
      'isOnline': false,
    },
    {
      'id': '3',
      'userName': 'محمد علي',
      'lastMessage': 'هل يمكنني تجديد الاشتراك؟',
      'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
      'unreadCount': 1,
      'isOnline': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('الدعم الفني', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF00FF57)),
            onPressed: () {
              // TODO: البحث في المحادثات
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildStatsHeader(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                final conversation = conversations[index];
                return _buildConversationTile(conversation);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsHeader() {
    final unreadTotal = conversations.fold<int>(0, (sum, conv) => sum + (conv['unreadCount'] as int));
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('المحادثات النشطة', conversations.length.toString(), Icons.chat),
          _buildStatItem('الرسائل غير المقروءة', unreadTotal.toString(), Icons.mark_chat_unread),
          _buildStatItem('المتصلين الآن', '2', Icons.circle, Colors.green),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon, [Color? iconColor]) {
    return Column(
      children: [
        Icon(icon, color: iconColor ?? const Color(0xFF00FF57), size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          title,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildConversationTile(Map<String, dynamic> conversation) {
    final timeFormat = DateFormat('HH:mm');
    final dateFormat = DateFormat('dd/MM');
    final now = DateTime.now();
    final timestamp = conversation['timestamp'] as DateTime;
    final isToday = timestamp.day == now.day && timestamp.month == now.month;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFF00FF57),
              child: Text(
                conversation['userName'][0],
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            if (conversation['isOnline'])
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    border: Border.all(color: const Color(0xFF2C2C2E), width: 2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
          ],
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              conversation['userName'],
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Text(
              isToday ? timeFormat.format(timestamp) : dateFormat.format(timestamp),
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            conversation['lastMessage'],
            style: const TextStyle(color: Colors.white70),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: conversation['unreadCount'] > 0
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF00FF57),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  conversation['unreadCount'].toString(),
                  style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              )
            : null,
        onTap: () => _openChatScreen(conversation),
      ),
    );
  }

  void _openChatScreen(Map<String, dynamic> conversation) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(conversation: conversation),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final Map<String, dynamic> conversation;
  
  const ChatScreen({super.key, required this.conversation});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  List<Map<String, dynamic>> messages = [
    {
      'text': 'مرحباً، أريد الاستفسار عن أوقات العمل',
      'isFromUser': true,
      'timestamp': DateTime.now().subtract(const Duration(minutes: 30)),
    },
    {
      'text': 'مرحباً بك! أوقات عمل الصالة من 6 صباحاً حتى 11 مساءً جميع أيام الأسبوع',
      'isFromUser': false,
      'timestamp': DateTime.now().subtract(const Duration(minutes: 25)),
    },
    {
      'text': 'شكراً لك، وما هي أسعار الاشتراكات؟',
      'isFromUser': true,
      'timestamp': DateTime.now().subtract(const Duration(minutes: 20)),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C2C2E),
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFF00FF57),
              radius: 18,
              child: Text(
                widget.conversation['userName'][0],
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.conversation['userName'],
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  widget.conversation['isOnline'] ? 'متصل الآن' : 'غير متصل',
                  style: TextStyle(
                    color: widget.conversation['isOnline'] ? Colors.green : Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.call, color: Color(0xFF00FF57)),
            onPressed: () {
              // TODO: إجراء مكالمة
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // TODO: خيارات إضافية
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isFromUser = message['isFromUser'] as bool;
    final timeFormat = DateFormat('HH:mm');
    
    return Align(
      alignment: isFromUser ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isFromUser ? const Color(0xFF2C2C2E) : const Color(0xFF00FF57),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message['text'],
              style: TextStyle(
                color: isFromUser ? Colors.white : Colors.black,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              timeFormat.format(message['timestamp']),
              style: TextStyle(
                color: isFromUser ? Colors.white54 : Colors.black54,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF2C2C2E),
        border: Border(top: BorderSide(color: Colors.white12)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'اكتب رسالتك...',
                hintStyle: const TextStyle(color: Colors.white54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color(0xFF1C1C1E),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              maxLines: null,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF00FF57),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.black),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        messages.add({
          'text': _messageController.text.trim(),
          'isFromUser': false,
          'timestamp': DateTime.now(),
        });
      });
      
      _messageController.clear();
      
      // التمرير إلى أسفل
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }
}