import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/user_service.dart';
import '../widgets/logo.dart';
import 'diary_screen.dart';
import 'calendar_screen.dart';
import 'analysis_screen.dart';
import 'tracking_screen.dart';
import 'login_screen.dart';
import 'ai_chat_screen.dart';
import 'exercise_screen.dart';
import 'sync_screen.dart';
import 'stress_screen.dart';
import 'notes_screen.dart';
import 'weather_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  int _selectedDay = 1; // 0=CN, 1=T2... 6=T7

  final List<String> _days = ['CN', 'Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7'];

  // Diary data per day
  final Map<int, Map<String, dynamic>> _diaryByDay = {
    0: {
      'entries': ['Nghỉ ngơi cả ngày', 'Đi dạo buổi sáng 20 phút', 'Ngủ trưa 1 tiếng'],
      'status': 'Khỏe mạnh', 'statusColor': 'green', 'progress': '3/25',
      'meds': [
        {'name': 'Vitamin C 1000mg', 'time': '8:00 AM', 'colors': [AppTheme.success, const Color(0xFF14B8A6)]},
      ],
      'stats': {'heart': '68 bpm', 'steps': '3,200', 'sleep': '8h 30m', 'water': '2.0L / 2.5L'},
    },
    1: {
      'entries': ['Uống thuốc hạ sốt lúc 8:00 sáng', 'Đau đầu nhẹ từ 14:00 - 15:30', 'Tập thể dục 30 phút buổi sáng'],
      'status': 'Khá tốt', 'statusColor': 'green', 'progress': '4/25',
      'meds': [
        {'name': 'Paracetamol 500mg', 'time': '8:00 AM', 'colors': [AppTheme.warning, AppTheme.danger]},
        {'name': 'Ibuprofen 200mg', 'time': '12:00 PM', 'colors': [AppTheme.accent, const Color(0xFF8B5CF6)]},
        {'name': 'Vitamin C 1000mg', 'time': '7:00 PM', 'colors': [AppTheme.success, const Color(0xFF14B8A6)]},
      ],
      'stats': {'heart': '72 bpm', 'steps': '6,842', 'sleep': '7h 30m', 'water': '1.5L / 2.5L'},
    },
    2: {
      'entries': ['Ngủ dậy muộn, mệt mỏi nhẹ', 'Họp online 3 tiếng liên tục', 'Đau vai gáy buổi chiều'],
      'status': 'Trung bình', 'statusColor': 'yellow', 'progress': '5/25',
      'meds': [
        {'name': 'Ibuprofen 200mg', 'time': '14:00 PM', 'colors': [AppTheme.accent, const Color(0xFF8B5CF6)]},
        {'name': 'Omega-3', 'time': '8:00 PM', 'colors': [AppTheme.primary, AppTheme.primaryLight]},
      ],
      'stats': {'heart': '78 bpm', 'steps': '4,100', 'sleep': '6h 00m', 'water': '1.2L / 2.5L'},
    },
    3: {
      'entries': ['Tập gym 45 phút', 'Ăn salad trưa', 'Cảm thấy năng lượng tốt'],
      'status': 'Tốt', 'statusColor': 'green', 'progress': '6/25',
      'meds': [
        {'name': 'Vitamin C 1000mg', 'time': '7:00 AM', 'colors': [AppTheme.success, const Color(0xFF14B8A6)]},
        {'name': 'Omega-3', 'time': '8:00 PM', 'colors': [AppTheme.primary, AppTheme.primaryLight]},
      ],
      'stats': {'heart': '70 bpm', 'steps': '9,100', 'sleep': '8h 00m', 'water': '2.3L / 2.5L'},
    },
    4: {
      'entries': ['Đau đầu nặng buổi sáng', 'Nghỉ ở nhà, không tập thể dục', 'Uống thuốc giảm đau'],
      'status': 'Không tốt', 'statusColor': 'red', 'progress': '7/25',
      'meds': [
        {'name': 'Paracetamol 500mg', 'time': '7:00 AM', 'colors': [AppTheme.warning, AppTheme.danger]},
        {'name': 'Ibuprofen 200mg', 'time': '10:00 AM', 'colors': [AppTheme.accent, const Color(0xFF8B5CF6)]},
        {'name': 'Vitamin C 1000mg', 'time': '7:00 PM', 'colors': [AppTheme.success, const Color(0xFF14B8A6)]},
      ],
      'stats': {'heart': '82 bpm', 'steps': '2,300', 'sleep': '5h 30m', 'water': '1.0L / 2.5L'},
    },
    5: {
      'entries': ['Chạy bộ 5km buổi sáng', 'Yoga 20 phút', 'Sức khỏe ổn định'],
      'status': 'Rất tốt', 'statusColor': 'green', 'progress': '8/25',
      'meds': [
        {'name': 'Vitamin C 1000mg', 'time': '7:00 AM', 'colors': [AppTheme.success, const Color(0xFF14B8A6)]},
      ],
      'stats': {'heart': '65 bpm', 'steps': '11,200', 'sleep': '7h 45m', 'water': '2.8L / 2.5L'},
    },
    6: {
      'entries': ['Đi leo núi cùng bạn bè', 'Ăn BBQ buổi tối', 'Ngủ sớm lúc 21:30'],
      'status': 'Tốt', 'statusColor': 'green', 'progress': '9/25',
      'meds': [
        {'name': 'Vitamin C 1000mg', 'time': '8:00 AM', 'colors': [AppTheme.success, const Color(0xFF14B8A6)]},
        {'name': 'Omega-3', 'time': '9:00 PM', 'colors': [AppTheme.primary, AppTheme.primaryLight]},
      ],
      'stats': {'heart': '70 bpm', 'steps': '14,500', 'sleep': '8h 15m', 'water': '3.0L / 2.5L'},
    },
  };

  void _logout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(children: [
          Icon(Icons.logout, color: AppTheme.danger, size: 22), SizedBox(width: 8),
          Text('Đăng xuất', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
        ]),
        content: const Text('Bạn có chắc chắn muốn đăng xuất không?', style: TextStyle(fontSize: 14)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy', style: TextStyle(color: AppTheme.textMuted))),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              UserService().logout();
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.danger, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHome(),
          const TrackingScreen(),
          const CalendarScreen(),
          const AnalysisScreen(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: _currentIndex == 0 ? FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AiChatScreen())),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          width: 56, height: 56,
          decoration: const BoxDecoration(shape: BoxShape.circle, gradient: AppTheme.primaryGradient,
            boxShadow: [BoxShadow(color: Color(0x664361EE), blurRadius: 12, offset: Offset(0, 4))]),
          child: const Icon(Icons.smart_toy, color: Colors.white, size: 26),
        ),
      ) : null,
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.bgDarker.withValues(alpha: 0.95),
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.06))),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(children: [
            _navItem(0, Icons.home_rounded, 'Trang Chủ'),
            _navItem(1, Icons.explore_outlined, 'Khám Phá'),
            _navItem(2, Icons.show_chart_rounded, 'Theo Dõi'),
            _navItem(3, Icons.more_horiz, 'Thêm'),
          ]),
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label) {
    final isActive = _currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentIndex = index),
        behavior: HitTestBehavior.opaque,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isActive ? AppTheme.accent.withValues(alpha: 0.15) : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: isActive ? AppTheme.accent : Colors.white.withValues(alpha: 0.4), size: 24),
          ),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 10, fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive ? AppTheme.accent : Colors.white.withValues(alpha: 0.4))),
        ]),
      ),
    );
  }

  Widget _buildHome() {
    final user = UserService().currentUser;
    final displayName = user != null ? '${user.firstName} ${user.lastName}' : 'User';
    final dayData = _diaryByDay[_selectedDay]!;

    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.darkGradient),
      child: Column(
        children: [
          // Header
          Container(
            decoration: const BoxDecoration(
              gradient: AppTheme.headerGradient,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Column(children: [
                  Row(children: [
                    Container(width: 36, height: 36,
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.monitor_heart, color: Colors.white, size: 20)),
                    const SizedBox(width: 10),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('HealthTrack', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                      Text('Xin chào, $displayName 👋', style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.8))),
                    ]),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text('🔔 Nhắc nhở: Uống Vitamin C lúc 19:00'),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ));
                      },
                      child: Container(width: 36, height: 36,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.15)),
                        child: Stack(children: [
                          const Center(child: Icon(Icons.notifications_outlined, color: Colors.white, size: 20)),
                          Positioned(top: 6, right: 6, child: Container(width: 8, height: 8,
                            decoration: const BoxDecoration(shape: BoxShape.circle, color: AppTheme.danger))),
                        ]),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _logout,
                      child: CircleAvatar(radius: 18, backgroundColor: Colors.white.withValues(alpha: 0.3),
                        child: Text(user != null ? user.firstName[0].toUpperCase() : 'U',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16))),
                    ),
                  ]),
                  const SizedBox(height: 16),
                  // Day tabs
                  SizedBox(
                    height: 36,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _days.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 6),
                      itemBuilder: (context, i) {
                        final isActive = _selectedDay == i;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedDay = i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: Text(_days[i], style: TextStyle(
                              fontSize: 12, fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                              color: isActive ? AppTheme.primary : Colors.white.withValues(alpha: 0.7),
                            )),
                          ),
                        );
                      },
                    ),
                  ),
                ]),
              ),
            ),
          ),
          // Checkin + Icon Grid
          _buildCheckinSection(),
          // Body – changes when day is tapped
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(children: [
                _diarySection(dayData),
                const SizedBox(height: 16),
                _healthSummary(dayData['stats']),
                const SizedBox(height: 16),
                _quickActions(),
                const SizedBox(height: 16),
                _locationCard(),
                const SizedBox(height: 10),
                _medicineReminder(dayData),
                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckinSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Column(
        children: [
          // Back arrow
          Align(
            alignment: Alignment.centerLeft,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  if (_currentIndex > 0) setState(() => _currentIndex--);
                },
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(Icons.chevron_left, color: Colors.white.withValues(alpha: 0.7), size: 28),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Checkin button
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text('✅ Check-in thành công hôm nay!'),
                backgroundColor: AppTheme.success,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ));
            },
            child: Column(
              children: [
                Container(
                  width: 70, height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF6B35), Color(0xFFE63946)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(color: const Color(0xFFE63946).withValues(alpha: 0.4), blurRadius: 16, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: const Icon(Icons.directions_walk, color: Colors.white, size: 32),
                ),
                const SizedBox(height: 6),
                const Text('Checkin', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // 4 icons row 1: Tác nhân, Điều trị, Triệu chứng, Đồng bộ
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _gridIcon(Icons.psychology, 'Tác nhân', const Color(0xFF3A86FF), () {
                setState(() => _currentIndex = 2); // go to calendar with triggers tab
              }),
              _gridIcon(Icons.favorite, 'Điều trị', const Color(0xFF3A86FF), () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const DiaryScreen()));
              }),
              _gridIcon(Icons.accessibility_new, 'Triệu chứng', const Color(0xFF3A86FF), () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const DiaryScreen()));
              }),
              _gridIcon(Icons.sync, 'Đồng bộ', const Color(0xFF3A86FF), () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SyncScreen()));
              }),
            ],
          ),
          const SizedBox(height: 12),
          // 4 icons row 2: Căng Thẳng, Ghi chú, Thời Tiết, Luyện tập
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _gridIcon(Icons.self_improvement, 'Căng Thẳng', const Color(0xFF3A86FF), () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const StressScreen()));
              }),
              _gridIcon(Icons.sticky_note_2, 'Ghi chú', const Color(0xFF3A86FF), () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const NotesScreen()));
              }),
              _gridIcon(Icons.cloud, 'Thời Tiết', const Color(0xFF3A86FF), () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const WeatherScreen()));
              }),
              _gridIcon(Icons.fitness_center, 'Luyện tập', const Color(0xFF3A86FF), () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ExerciseScreen()));
              }),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _gridIcon(IconData icon, String label, Color color, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        splashColor: color.withValues(alpha: 0.3),
        highlightColor: color.withValues(alpha: 0.1),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Column(
            children: [
              Container(
                width: 50, height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A2560),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _diarySection(Map<String, dynamic> dayData) {
    final entries = dayData['entries'] as List<String>;
    final meds = dayData['meds'] as List<Map<String, dynamic>>;
    final statusColor = dayData['statusColor'] == 'green' ? AppTheme.success :
                        dayData['statusColor'] == 'red' ? AppTheme.danger : AppTheme.warning;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: [
        Row(children: [
          Text('Nhật ký ${_days[_selectedDay]}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
          const Spacer(),
          GestureDetector(
            onTap: () { if (_selectedDay > 0) setState(() => _selectedDay--); },
            child: _iconBtn(Icons.chevron_left),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () { if (_selectedDay < 6) setState(() => _selectedDay++); },
            child: _iconBtn(Icons.chevron_right),
          ),
        ]),
        const SizedBox(height: 12),
        Container(
          width: double.infinity, padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(10)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(entries.length, (i) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text('${i + 1}. ${entries[i]}', style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.7))),
            )),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [statusColor, AppTheme.accent]),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(children: [
            Container(width: 10, height: 10, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white)),
            const SizedBox(width: 8),
            Text('Tình trạng: ${dayData['status']}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white)),
            const Spacer(),
            Text(dayData['progress'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
          ]),
        ),
        const SizedBox(height: 12),
        ...meds.map((m) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: m['colors'] as List<Color>),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(children: [
              const Icon(Icons.medication, color: Colors.white, size: 18),
              const SizedBox(width: 12),
              Expanded(child: Text(m['name'], style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500))),
              Text(m['time'], style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 11)),
            ]),
          ),
        )),
      ]),
    );
  }

  Widget _healthSummary(Map<String, String> stats) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Tổng quan ${_days[_selectedDay]}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
        const SizedBox(height: 14),
        Row(children: [
          _statCard('💓', 'Nhịp tim', stats['heart']!, AppTheme.danger),
          const SizedBox(width: 10),
          _statCard('🏃', 'Bước chân', stats['steps']!, AppTheme.accent),
        ]),
        const SizedBox(height: 10),
        Row(children: [
          _statCard('😴', 'Giấc ngủ', stats['sleep']!, const Color(0xFF8B5CF6)),
          const SizedBox(width: 10),
          _statCard('💧', 'Nước uống', stats['water']!, AppTheme.success),
        ]),
      ]),
    );
  }

  Widget _statCard(String emoji, String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(emoji, style: const TextStyle(fontSize: 18)), const SizedBox(width: 6),
            Text(label, style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.6))),
          ]),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
        ]),
      ),
    );
  }

  Widget _quickActions() {
    final actions = [
      {'icon': Icons.add_circle_outline, 'label': 'Thêm triệu chứng', 'onTap': () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const DiaryScreen()));
      }},
      {'icon': Icons.smart_toy, 'label': 'Chat với AI', 'onTap': () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const AiChatScreen()));
      }},
      {'icon': Icons.coronavirus, 'label': 'Triệu Chứng', 'onTap': () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('📋 Đau đầu nhẹ • Mệt mỏi • Chóng mặt'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ));
      }},
      {'icon': Icons.group, 'label': 'Bộ Theo Dõi', 'onTap': () => setState(() => _currentIndex = 1)},
    ];

    return GridView.count(
      crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 2.5,
      children: actions.map((a) => GestureDetector(
        onTap: a['onTap'] as VoidCallback,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(children: [
            Icon(a['icon'] as IconData, color: AppTheme.accent, size: 20), const SizedBox(width: 8),
            Flexible(child: Text(a['label'] as String, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500))),
          ]),
        ),
      )).toList(),
    );
  }

  Widget _locationCard() {
    return GestureDetector(
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('📍 TP.HCM - 32°C, Độ ẩm 75%, Áp suất thấp'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      )),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(children: [
          const Icon(Icons.location_on, color: AppTheme.accent, size: 18), const SizedBox(width: 10),
          Expanded(child: Text('📍 TP.HCM - 32°C, Độ ẩm 75%', style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.7)))),
          Container(width: 28, height: 28, decoration: const BoxDecoration(shape: BoxShape.circle, color: AppTheme.primary),
            child: const Icon(Icons.refresh, color: Colors.white, size: 16)),
        ]),
      ),
    );
  }

  Widget _medicineReminder(Map<String, dynamic> dayData) {
    final meds = dayData['meds'] as List<Map<String, dynamic>>;
    return GestureDetector(
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('💊 ${meds.length} thuốc cần uống ${_days[_selectedDay]}'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      )),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(children: [
          const Icon(Icons.medication_liquid, color: AppTheme.warning, size: 18), const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('THUỐC CẦN UỐNG', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.warning)),
            const SizedBox(height: 2),
            Text('${meds.length} loại thuốc trong ngày', style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.5))),
          ])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: AppTheme.warning, borderRadius: BorderRadius.circular(8)),
            child: Text('${meds.length}', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
          ),
        ]),
      ),
    );
  }

  Widget _iconBtn(IconData icon) {
    return Container(width: 30, height: 30,
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
      child: Icon(icon, color: Colors.white, size: 18));
  }
}
