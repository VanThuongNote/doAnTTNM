import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../widgets/logo.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> with TickerProviderStateMixin {
  final _controller = TextEditingController();
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isTyping = false;
  bool _showStartScreen = true;
  bool _showSidebar = false;
  bool _isRecording = false;
  int _selectedTheme = 1; // 0=default, 1=dark, 2=light

  final List<Map<String, dynamic>> _messages = [];

  final List<Map<String, String>> _chatHistory = [
    {'title': 'Hôm nay ăn gì', 'preview': 'Gợi ý thực đơn lành mạnh...'},
    {'title': 'Vấn đề kiêng cữ', 'preview': 'Thực phẩm nên tránh khi...'},
    {'title': 'Tôi bị bệnh gì và...', 'preview': 'Phân tích triệu chứng...'},
    {'title': 'Vấn đề không cữ', 'preview': 'Tư vấn chế độ ăn uống...'},
  ];

  // AI response database
  final Map<String, String> _responses = {
    'đau đầu': '🧠 **Về triệu chứng đau đầu:**\n\nDựa trên dữ liệu của bạn, đau đầu xuất hiện 3 lần/tuần, chủ yếu vào buổi chiều.\n\n**Nguyên nhân có thể:**\n• Thiếu ngủ (TB 6.5h/đêm)\n• Stress công việc\n• Áp suất khí quyển thấp\n\n**Gợi ý:**\n1. Uống đủ 2.5L nước/ngày\n2. Nghỉ mắt 5 phút mỗi giờ\n3. Tập thiền 10 phút/ngày',
    'mệt mỏi': '😴 **Phân tích mệt mỏi:**\n\nBạn báo mệt mỏi 5 lần/tuần.\n\n**Yếu tố ảnh hưởng:**\n• Giấc ngủ thiếu (TB 6.5h)\n• Cà phê cao (2-3 ly/ngày)\n• Thiếu vận động\n\n**Kế hoạch cải thiện:**\n1. Ngủ đủ 7-8h mỗi đêm\n2. Giảm cà phê xuống 1 ly/ngày\n3. Tập thể dục 30 phút/ngày',
    'ngủ': '😴 **Giấc ngủ tuần này:**\n\n• TB: 7.1h/đêm\n• Chất lượng: 71% tốt\n• Tốt nhất: T7 (8.5h)\n• Kém nhất: T5 (5.5h)\n\n**Mẹo:**\n1. Phòng ngủ 22°C\n2. Không điện thoại 30p trước ngủ\n3. Trà hoa cúc buổi tối',
    'thuốc': '💊 **Lịch thuốc hôm nay:**\n\n✅ Paracetamol 500mg - 8:00 AM\n✅ Ibuprofen 200mg - 12:00 PM\n⏳ Vitamin C 1000mg - 7:00 PM\n⏳ Omega-3 - 8:00 PM\n\n⚠️ Nhớ uống đủ thuốc!',
    'ăn': '🥗 **Gợi ý dinh dưỡng:**\n\n**Bữa sáng (7:00):**\n• Yến mạch + trái cây\n\n**Bữa trưa (12:00):**\n• Cơm gạo lứt + cá hồi + rau\n\n**Bữa tối (18:30):**\n• Salad gà + khoai lang\n\n⚠️ Hạn chế: đồ chiên, cà phê sau 14:00',
    'stress': '🧘 **Quản lý stress:**\n\nMức stress: 6/10\n\n**Bài tập giảm stress:**\n1. Thở sâu 4-7-8\n2. Thiền 10 phút/sáng\n3. Đi bộ thiên nhiên\n4. Nhạc thư giãn\n5. Viết nhật ký cảm xúc',
    'nước': '💧 **Nước uống hôm nay:**\n\nĐã uống: 1.5L / 2.5L (60%)\nCòn cần: 1.0L\n\n**Nhắc nhở:**\n• Uống 1 cốc mỗi 2 tiếng\n• Uống nhiều nước giảm đau đầu!',
    'tập': '🏃 **Vận động tuần này:**\n\n• TB: 7,671 bước/ngày\n• Tổng calo: 2,490 kcal\n• Tốt nhất: T7 (11,000 bước)\n\n**Gợi ý:**\n1. Tăng bước chân\n2. Thêm yoga 15p/sáng\n3. Đi bộ 20p sau ăn tối',
    'kiêng': '🥦 **Thực phẩm nên kiêng:**\n\nDựa trên tình trạng sức khỏe:\n• ❌ Đồ chiên, nhiều dầu mỡ\n• ❌ Thức ăn nhanh\n• ❌ Đường tinh luyện\n• ❌ Rượu bia\n• ❌ Cà phê quá 2 ly/ngày\n\n✅ Nên ăn: rau xanh, cá, trái cây, hạt',
    'bệnh': '🏥 **Phân tích triệu chứng:**\n\nDựa trên dữ liệu theo dõi:\n• Đau đầu: 3 lần/tuần\n• Mệt mỏi: 5 lần/tuần\n• Chóng mặt: 2 lần/tuần\n\n⚠️ Khuyến nghị: Nên đi khám bác sĩ chuyên khoa thần kinh.\n\n*Lưu ý: AI chỉ tham khảo, không thay thế bác sĩ.*',
  };

  void _startChat() {
    setState(() {
      _showStartScreen = false;
      _messages.add({
        'isBot': true,
        'text': 'Xin chào mình là trợ lý AI của bạn. Bạn cần mình giúp gì hôm nay?',
        'time': _currentTime(),
      });
    });
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'isBot': false, 'text': text, 'time': _currentTime()});
      _isTyping = true;
    });
    _controller.clear();
    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      final response = _findResponse(text);
      setState(() {
        _isTyping = false;
        _messages.add({'isBot': true, 'text': response, 'time': _currentTime()});
      });
      _scrollToBottom();
    });
  }

  String _findResponse(String input) {
    final lower = input.toLowerCase();
    for (final key in _responses.keys) {
      if (lower.contains(key)) return _responses[key]!;
    }
    if (lower.contains('chào') || lower.contains('hello') || lower.contains('hi')) {
      return 'Xin chào! 👋 Bạn có thể hỏi về: triệu chứng, thuốc, giấc ngủ, tập thể dục, dinh dưỡng, stress...';
    }
    if (lower.contains('cảm ơn')) {
      return 'Không có gì! 😊 Chúc bạn sức khỏe tốt! 💪';
    }
    if (lower.contains('sức khỏe') || lower.contains('tình trạng')) {
      return '📊 **Tổng quan hôm nay:**\n\n• Nhịp tim: 72 bpm ✅\n• Huyết áp: 120/80 ✅\n• SpO2: 98% ✅\n• Bước: 6,842/10,000\n• Nước: 1.5L/2.5L\n• Giấc ngủ: 7h\n\n✅ Tổng thể: Khá tốt!';
    }
    return '🤔 Tôi có thể giúp bạn về:\n\n• "đau đầu" - Phân tích triệu chứng\n• "mệt mỏi" - Nguyên nhân & giải pháp\n• "ngủ" - Phân tích giấc ngủ\n• "thuốc" - Lịch uống thuốc\n• "ăn" / "kiêng" - Dinh dưỡng\n• "tập" - Phân tích vận động\n• "stress" - Quản lý stress\n• "bệnh" - Phân tích triệu chứng\n\nHãy thử hỏi!';
  }

  String _currentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
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

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF252A5E),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            _attachOption(Icons.camera_alt, 'Máy ảnh', AppTheme.accent, () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text('📷 Đang mở máy ảnh...'),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ));
            }),
            _attachOption(Icons.image, 'Hình ảnh', AppTheme.success, () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text('🖼️ Chọn hình ảnh từ thư viện...'),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ));
            }),
            _attachOption(Icons.attach_file, 'Tệp đính kèm', AppTheme.warning, () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text('📎 Chọn tệp đính kèm...'),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ));
            }),
          ],
        ),
      ),
    );
  }

  Widget _attachOption(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 15)),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showStartScreen) return _buildStartScreen();
    return _buildChatScreen();
  }

  // ============ START SCREEN ============
  Widget _buildStartScreen() {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.headerGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 12),
                  const Text('Trợ Lý AI', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => setState(() => _showSidebar = !_showSidebar),
                    child: const Icon(Icons.menu, color: Colors.white, size: 22),
                  ),
                ]),
              ),
              // AI Avatar + Animation
              const Spacer(),
              const AiBotAvatar(size: 120),
              const SizedBox(height: 30),
              // Rotating glow circles
              Container(
                width: 200, height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
                ),
              ),
              const Spacer(),
              // Start Button
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 40),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _startChat,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.15),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                    ),
                    child: const Text('Start', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============ CHAT SCREEN ============
  Widget _buildChatScreen() {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.darkGradient),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                    decoration: BoxDecoration(
                      color: AppTheme.bgDarker.withValues(alpha: 0.5),
                      border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.06))),
                    ),
                    child: Row(children: [
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              backgroundColor: const Color(0xFF252A5E),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              content: const Text('Xác nhận thoát khỏi cuộc trò chuyện',
                                  style: TextStyle(color: Colors.white, fontSize: 14), textAlign: TextAlign.center),
                              actions: [
                                TextButton(
                                  onPressed: () { Navigator.pop(ctx); Navigator.pop(context); },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                    decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(8)),
                                    child: const Text('Đồng ý', style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text('Hủy', style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
                      ),
                      const SizedBox(width: 12),
                      const Text('Trợ Lý AI', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => setState(() => _showSidebar = !_showSidebar),
                        child: const Icon(Icons.menu, color: Colors.white, size: 22),
                      ),
                    ]),
                  ),
                  // Messages
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                      itemCount: _messages.length + (_isTyping ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _messages.length && _isTyping) return _typingIndicator();
                        return _messageWidget(_messages[index], index);
                      },
                    ),
                  ),
                  // Recording indicator
                  if (_isRecording)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      color: AppTheme.primary.withValues(alpha: 0.2),
                      child: Row(children: [
                        const Icon(Icons.mic, color: AppTheme.danger, size: 18),
                        const SizedBox(width: 8),
                        Text('Đang ghi âm', style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13)),
                        const Spacer(),
                        const SizedBox(width: 60, child: LinearProgressIndicator(
                          backgroundColor: Colors.white12, valueColor: AlwaysStoppedAnimation(AppTheme.danger),
                        )),
                      ]),
                    ),
                  // Input bar
                  Container(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                    decoration: BoxDecoration(
                      color: AppTheme.bgDarker.withValues(alpha: 0.8),
                      border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.06))),
                    ),
                    child: Row(children: [
                      // Attachment button
                      GestureDetector(
                        onTap: _showAttachmentOptions,
                        child: Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.1)),
                          child: const Icon(Icons.add, color: Colors.white, size: 20),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Text input
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF252A5E),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                          ),
                          child: TextField(
                            controller: _controller,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            cursorColor: Colors.white,
                            decoration: const InputDecoration(
                              hintText: 'Nhập nội dung...',
                              hintStyle: TextStyle(color: Color(0xFF8B8FA8)),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              filled: false,
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            ),
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Mic button
                      GestureDetector(
                        onTap: () => setState(() => _isRecording = !_isRecording),
                        child: Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isRecording ? AppTheme.danger : Colors.white.withValues(alpha: 0.1),
                          ),
                          child: Icon(_isRecording ? Icons.stop : Icons.mic, color: Colors.white, size: 18),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Send button
                      GestureDetector(
                        onTap: _sendMessage,
                        child: Container(
                          width: 36, height: 36,
                          decoration: const BoxDecoration(shape: BoxShape.circle, gradient: AppTheme.primaryGradient),
                          child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
              // Sidebar overlay
              if (_showSidebar) _buildSidebar(),
            ],
          ),
        ),
      ),
    );
  }

  // ============ SIDEBAR ============
  Widget _buildSidebar() {
    return GestureDetector(
      onTap: () => setState(() => _showSidebar = false),
      child: Container(
        color: Colors.black.withValues(alpha: 0.4),
        child: Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {},
            child: Container(
              width: MediaQuery.of(context).size.width * 0.78,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFF1A1D3E), Color(0xFF252A5E)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              ),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
                        ),
                        child: TextField(
                          controller: _searchController,
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                          decoration: InputDecoration(
                            hintText: 'Tìm kiếm cuộc trò chuyện...',
                            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            suffixIcon: const Icon(Icons.search, color: Colors.white54, size: 20),
                          ),
                        ),
                      ),
                    ),
                    // New conversation
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _messages.clear();
                            _messages.add({
                              'isBot': true,
                              'text': 'Xin chào mình là trợ lý AI của bạn. Bạn cần mình giúp gì hôm nay?',
                              'time': _currentTime(),
                            });
                            _showSidebar = false;
                          });
                        },
                        child: Row(children: [
                          Text('Cuộc trò chuyện mới', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
                          const SizedBox(width: 6),
                          const Icon(Icons.add, color: AppTheme.accent, size: 18),
                        ]),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Chat history
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GestureDetector(
                        onTap: () {},
                        child: Row(children: [
                          Text('Lịch sử trò chuyện', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
                          const SizedBox(width: 4),
                          Icon(Icons.expand_more, color: Colors.white.withValues(alpha: 0.5), size: 18),
                        ]),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...List.generate(_chatHistory.length, (i) {
                      final item = _chatHistory[i];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(24, 4, 16, 4),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _messages.clear();
                              _messages.add({'isBot': true, 'text': 'Xin chào! Bạn muốn tiếp tục về "${item['title']}"?', 'time': _currentTime()});
                              _showSidebar = false;
                            });
                          },
                          child: Row(children: [
                            Expanded(child: Text(item['title']!, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13))),
                            PopupMenuButton<String>(
                              icon: Icon(Icons.more_vert, color: Colors.white.withValues(alpha: 0.3), size: 16),
                              color: const Color(0xFF2D3270),
                              onSelected: (val) {
                                if (val == 'rename') {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: const Text('✏️ Đổi tên cuộc trò chuyện'),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ));
                                } else if (val == 'delete') {
                                  setState(() => _chatHistory.removeAt(i));
                                }
                              },
                              itemBuilder: (_) => [
                                const PopupMenuItem(value: 'rename', child: Row(children: [
                                  Icon(Icons.edit, color: Colors.white70, size: 16), SizedBox(width: 8),
                                  Text('Đổi tên', style: TextStyle(color: Colors.white, fontSize: 13)),
                                ])),
                                const PopupMenuItem(value: 'delete', child: Row(children: [
                                  Icon(Icons.delete, color: AppTheme.danger, size: 16), SizedBox(width: 8),
                                  Text('Xóa cuộc trò chuyện', style: TextStyle(color: AppTheme.danger, fontSize: 13)),
                                ])),
                              ],
                            ),
                          ]),
                        ),
                      );
                    }),
                    const Divider(color: Colors.white12, indent: 16, endIndent: 16),
                    // Topics
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Row(children: [
                        Text('Chủ đề', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
                        const SizedBox(width: 4),
                        Icon(Icons.expand_more, color: Colors.white.withValues(alpha: 0.5), size: 18),
                      ]),
                    ),
                    // Theme selector
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(children: [
                        _themeOption(0, 'Default Mode', const [Color(0xFF4361EE), Color(0xFF3A86FF)]),
                        const SizedBox(width: 10),
                        _themeOption(1, 'Dark Mode', const [Color(0xFF1A1D3E), Color(0xFF0F1128)]),
                        const SizedBox(width: 10),
                        _themeOption(2, 'Light Mode', const [Color(0xFFE2E8F0), Color(0xFFF8FAFC)]),
                      ]),
                    ),
                    const Spacer(),
                    // Export button
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text('📤 Đã xuất lịch sử trò chuyện'),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ));
                        },
                        child: Container(
                          width: 48, height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.1),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                          ),
                          child: const Icon(Icons.logout, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _themeOption(int index, String label, List<Color> colors) {
    final isActive = _selectedTheme == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTheme = index),
      child: Column(
        children: [
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: colors),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: isActive ? AppTheme.accent : Colors.transparent, width: 2),
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 9)),
        ],
      ),
    );
  }

  // ============ MESSAGE WIDGET ============
  Widget _messageWidget(Map<String, dynamic> msg, int index) {
    final isBot = msg['isBot'] as bool;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isBot) ...[
            const AiBotAvatar(size: 34),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: GestureDetector(
              onLongPress: () => _showMessageOptions(msg, index),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isBot ? Colors.white.withValues(alpha: 0.08) : AppTheme.primary.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(isBot ? 4 : 16),
                    topRight: Radius.circular(isBot ? 16 : 4),
                    bottomLeft: const Radius.circular(16),
                    bottomRight: const Radius.circular(16),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(msg['text'], style: TextStyle(
                      color: Colors.white.withValues(alpha: isBot ? 0.85 : 1.0), fontSize: 13, height: 1.5,
                    )),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(msg['time'], style: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 10)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (!isBot) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16, backgroundColor: Colors.grey[600],
              child: const Icon(Icons.person, color: Colors.white, size: 18),
            ),
          ],
        ],
      ),
    );
  }

  void _showMessageOptions(Map<String, dynamic> msg, int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF252A5E),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            _msgOption(Icons.copy, 'Sao chép', () {
              Navigator.pop(ctx);
              Clipboard.setData(ClipboardData(text: msg['text']));
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text('📋 Đã sao chép vào bộ nhớ tạm'),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ));
            }),
            if (msg['isBot'] == true)
              _msgOption(Icons.refresh, 'Tạo mới câu trả lời', () {
                Navigator.pop(ctx);
                setState(() {
                  _messages[index] = {'isBot': true, 'text': _findResponse('sức khỏe'), 'time': _currentTime()};
                });
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text('🔄 Đã tạo mới câu trả lời'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ));
              }),
            if (msg['isBot'] == false)
              _msgOption(Icons.edit, 'Chỉnh sửa câu trả lời', () {
                Navigator.pop(ctx);
                _controller.text = msg['text'];
              }),
            _msgOption(Icons.delete_outline, 'Xóa tin nhắn', () {
              Navigator.pop(ctx);
              setState(() => _messages.removeAt(index));
            }),
          ],
        ),
      ),
    );
  }

  Widget _msgOption(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(width: 14),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
        ]),
      ),
    );
  }

  Widget _typingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [
        const AiBotAvatar(size: 34),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4), topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16),
            ),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text('Đang ghi lâm ...', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12)),
            const SizedBox(width: 8),
            SizedBox(width: 16, height: 16, child: CircularProgressIndicator(
              strokeWidth: 2, color: AppTheme.accent.withValues(alpha: 0.5),
            )),
          ]),
        ),
      ]),
    );
  }
}
