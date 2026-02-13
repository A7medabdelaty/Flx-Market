import 'package:flutter/material.dart';

class ChatWithAdminPage extends StatefulWidget {
  const ChatWithAdminPage({super.key});

  @override
  State<ChatWithAdminPage> createState() => _ChatWithAdminPageState();
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isQuickReply;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isQuickReply = false,
  });
}

class QuickReplyOption {
  final String title;
  final String message;
  final String mockResponse;
  final IconData icon;

  QuickReplyOption({
    required this.title,
    required this.message,
    required this.mockResponse,
    required this.icon,
  });
}

class _ChatWithAdminPageState extends State<ChatWithAdminPage> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showQuickReplies = true;

  final List<QuickReplyOption> _quickReplies = [
    QuickReplyOption(
      title: 'Phones',
      message: 'Phones under 10000 EGP',
      mockResponse:
          'We have great phones under 10,000 EGP! Check out Samsung Galaxy A15 (8,500 EGP), Xiaomi Redmi 13 (7,200 EGP), and Realme C67 (6,800 EGP). Would you like to see more options?',
      icon: Icons.smartphone,
    ),
    QuickReplyOption(
      title: 'Apartments',
      message: 'Apartment with 150m area',
      mockResponse:
          'We found 5 apartments around 150m²: 2 in Nasr City (1.2M - 1.5M EGP), 2 in 6th of October (900K - 1.1M EGP), and 1 in New Cairo (1.8M EGP). Which area interests you?',
      icon: Icons.apartment,
    ),
    QuickReplyOption(
      title: 'Cars',
      message: 'Cars under 500000 EGP',
      mockResponse:
          'Popular cars under 500K EGP: Hyundai Accent 2023 (420K EGP), Kia Pegas 2024 (380K EGP), and Chevrolet Optra 2023 (450K EGP). Would you like details on financing options?',
      icon: Icons.directions_car,
    ),
    QuickReplyOption(
      title: 'Laptops',
      message: 'Gaming laptops under 30000 EGP',
      mockResponse:
          'Gaming laptops under 30K: HP Victus 15 (28,500 EGP), Lenovo IdeaPad Gaming 3 (26,000 EGP), and ASUS TUF F15 (29,500 EGP). All with RTX 3050. Need specs comparison?',
      icon: Icons.laptop,
    ),
    QuickReplyOption(
      title: 'Jobs',
      message: 'Software engineer jobs',
      mockResponse:
          'We have 12 Software Engineer positions: 5 remote, 4 hybrid in Cairo, 3 in Alexandria. Salary range: 15K-45K EGP. Would you like to filter by experience level?',
      icon: Icons.work,
    ),
    QuickReplyOption(
      title: 'Furniture',
      message: 'Sofa sets under 15000 EGP',
      mockResponse:
          'Beautiful sofa sets under 15K: 3-seater fabric (8,500 EGP), L-shaped corner sofa (14,000 EGP), and modern recliner set (12,500 EGP). Free delivery in Cairo!',
      icon: Icons.chair,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Add welcome message
    _addAdminMessage(
      'Hello! Welcome to Flx Market support. 👋\n\nHow can I help you today? Choose a quick option below or type your question.',
    );
  }

  void _addAdminMessage(String text) {
    setState(() {
      _messages.add(
        ChatMessage(text: text, isUser: false, timestamp: DateTime.now()),
      );
    });
    _scrollToBottom();
  }

  void _addUserMessage(String text, {bool isQuickReply = false}) {
    setState(() {
      _messages.add(
        ChatMessage(
          text: text,
          isUser: true,
          timestamp: DateTime.now(),
          isQuickReply: isQuickReply,
        ),
      );
      _showQuickReplies = false;
    });
    _scrollToBottom();
  }

  void _handleQuickReply(QuickReplyOption option) {
    _addUserMessage(option.message, isQuickReply: true);

    // Simulate typing delay
    Future.delayed(const Duration(milliseconds: 800), () {
      _addAdminMessage(option.mockResponse);
      setState(() {
        _showQuickReplies = true;
      });
    });
  }

  void _handleSendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    _addUserMessage(text);
    _textController.clear();

    // Simulate typing delay for custom messages
    Future.delayed(const Duration(milliseconds: 1000), () {
      _addAdminMessage(
        'Thank you for your message! 📩\n\nOur admin team will review your inquiry and contact you shortly. Typical response time is within 2-4 hours during business hours (9 AM - 9 PM).\n\nIs there anything else I can help you with in the meantime?',
      );
      setState(() {
        _showQuickReplies = true;
      });
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final showAvatar =
                    index == 0 || _messages[index - 1].isUser != message.isUser;

                return _buildMessageBubble(message, showAvatar);
              },
            ),
          ),
          if (_showQuickReplies) _buildQuickRepliesSection(),
          _buildInputArea(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF191555)),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4B3FFF), Color(0xFF6B5FFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.support_agent,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Flx Market Support',
                  style: TextStyle(
                    color: Color(0xFF191555),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Online',
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert, color: Color(0xFF191555)),
          onPressed: () {
            _showOptionsMenu();
          },
        ),
      ],
    );
  }

  void _showOptionsMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              _buildMenuItem(Icons.phone, 'Call Support', '0123-456-7890'),
              _buildMenuItem(Icons.email, 'Email Us', 'support@flxmarket.com'),
              _buildMenuItem(Icons.access_time, 'Working Hours', '9 AM - 9 PM'),
              _buildMenuItem(Icons.info_outline, 'About', 'Flx Market v1.0'),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuItem(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF4B3FFF).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: const Color(0xFF4B3FFF)),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Color(0xFF191555),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.grey[600], fontSize: 13),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, bool showAvatar) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: message.isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isUser && showAvatar) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4B3FFF), Color(0xFF6B5FFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.support_agent,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
          ] else if (!message.isUser) ...[
            const SizedBox(width: 40),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isUser ? const Color(0xFF4B3FFF) : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(message.isUser ? 18 : 4),
                  bottomRight: Radius.circular(message.isUser ? 4 : 18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser
                      ? Colors.white
                      : const Color(0xFF191555),
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.person, color: Colors.grey[600], size: 18),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickRepliesSection() {
    return Container(
      color: const Color(0xFFF0F2F5),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Options',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _quickReplies.length,
              itemBuilder: (context, index) {
                final reply = _quickReplies[index];
                return _buildQuickReplyCard(reply);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickReplyCard(QuickReplyOption reply) {
    return GestureDetector(
      onTap: () => _handleQuickReply(reply),
      child: IntrinsicWidth(
        child: Container(
          constraints: const BoxConstraints(minWidth: 140, maxWidth: 220),
          margin: const EdgeInsets.only(right: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4B3FFF).withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(color: const Color(0xFF4B3FFF).withOpacity(0.1)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF4B3FFF).withOpacity(0.15),
                      const Color(0xFF6B5FFF).withOpacity(0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  reply.icon,
                  color: const Color(0xFF4B3FFF),
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  reply.message,
                  style: const TextStyle(
                    color: Color(0xFF191555),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: 12 + MediaQuery.of(context).padding.bottom,
      ),
      child: SafeArea(
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF4B3FFF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: Color(0xFF4B3FFF),
                ),
                onPressed: () {
                  setState(() {
                    _showQuickReplies = !_showQuickReplies;
                  });
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F2F5),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.emoji_emotions_outlined,
                        color: Colors.grey[500],
                      ),
                      onPressed: () {},
                    ),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  onSubmitted: (_) => _handleSendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: _handleSendMessage,
              child: Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF4B3FFF), Color(0xFF6B5FFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.send, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
