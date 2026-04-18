import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  int _selectedTab = 0;
  final Set<int> _favorites = {0, 2, 4};

  final List<Map<String, dynamic>> _trackers = [
    {'icon': Icons.monitor_heart, 'name': 'Nhịp tim', 'value': '72 bpm', 'status': 'Bình thường', 'color': AppTheme.danger, 'fav': true},
    {'icon': Icons.bloodtype, 'name': 'Huyết áp', 'value': '120/80', 'status': 'Tốt', 'color': AppTheme.primary, 'fav': false},
    {'icon': Icons.thermostat, 'name': 'Nhiệt độ', 'value': '36.5°C', 'status': 'Bình thường', 'color': AppTheme.success, 'fav': true},
    {'icon': Icons.air, 'name': 'SpO2', 'value': '98%', 'status': 'Xuất sắc', 'color': AppTheme.accent, 'fav': false},
    {'icon': Icons.directions_walk, 'name': 'Bước chân', 'value': '6,842', 'status': '68% mục tiêu', 'color': AppTheme.orange, 'fav': true},
    {'icon': Icons.local_fire_department, 'name': 'Calo đốt', 'value': '425 kcal', 'status': '53% mục tiêu', 'color': AppTheme.pink, 'fav': false},
  ];

  final List<Map<String, dynamic>> _moodTriggers = [
    {'icon': Icons.sentiment_very_satisfied, 'name': 'Vui vẻ', 'count': 12, 'color': AppTheme.success},
    {'icon': Icons.sentiment_satisfied, 'name': 'Bình thường', 'count': 8, 'color': AppTheme.accent},
    {'icon': Icons.sentiment_dissatisfied, 'name': 'Mệt mỏi', 'count': 5, 'color': AppTheme.warning},
    {'icon': Icons.sentiment_very_dissatisfied, 'name': 'Stress', 'count': 3, 'color': AppTheme.danger},
  ];

  final List<Map<String, dynamic>> _symptoms = [
    {'name': 'Đau đầu', 'freq': '3 lần/tuần', 'severity': 'Nhẹ', 'color': AppTheme.warning},
    {'name': 'Mệt mỏi', 'freq': '5 lần/tuần', 'severity': 'Trung bình', 'color': AppTheme.orange},
    {'name': 'Mất ngủ', 'freq': '2 lần/tuần', 'severity': 'Nhẹ', 'color': AppTheme.accent},
    {'name': 'Đau bụng', 'freq': '1 lần/tuần', 'severity': 'Nhẹ', 'color': AppTheme.success},
    {'name': 'Chóng mặt', 'freq': '2 lần/tuần', 'severity': 'Nhẹ', 'color': AppTheme.primary},
  ];

  final List<Map<String, dynamic>> _specialTrackers = [
    {'name': 'Cà phê', 'icon': Icons.coffee, 'today': '2 ly', 'limit': '3 ly/ngày'},
    {'name': 'Nước', 'icon': Icons.water_drop, 'today': '1.5L', 'limit': '2.5L/ngày'},
    {'name': 'Bia', 'icon': Icons.local_bar, 'today': '0', 'limit': '1 lon/ngày'},
    {'name': 'Thuốc lá', 'icon': Icons.smoke_free, 'today': '0', 'limit': 'Không hút'},
    {'name': 'Đường', 'icon': Icons.cake, 'today': '15g', 'limit': '25g/ngày'},
    {'name': 'Sô cô la', 'icon': Icons.cookie, 'today': '1 thanh', 'limit': '2 thanh/ngày'},
  ];

  final List<Map<String, dynamic>> _availableTrackers = [
    {'icon': Icons.psychology, 'name': 'Trí nhớ', 'value': '--- ', 'status': 'Chưa đo', 'color': const Color(0xFF8B5CF6)},
    {'icon': Icons.water_drop, 'name': 'Lượng nước', 'value': '0L', 'status': 'Chưa ghi nhận', 'color': AppTheme.accent},
    {'icon': Icons.restaurant, 'name': 'Chế độ ăn', 'value': '---', 'status': 'Chưa cập nhật', 'color': AppTheme.success},
    {'icon': Icons.self_improvement, 'name': 'Thiền', 'value': '0 phút', 'status': 'Chưa bắt đầu', 'color': const Color(0xFFE040FB)},
    {'icon': Icons.mood, 'name': 'Tâm trạng', 'value': '---', 'status': 'Chưa ghi nhận', 'color': AppTheme.warning},
    {'icon': Icons.scale, 'name': 'Cân nặng', 'value': '--- kg', 'status': 'Chưa đo', 'color': AppTheme.orange},
    {'icon': Icons.visibility, 'name': 'Thị lực', 'value': '---', 'status': 'Chưa kiểm tra', 'color': AppTheme.primary},
    {'icon': Icons.hearing, 'name': 'Thính giác', 'value': '---', 'status': 'Chưa kiểm tra', 'color': AppTheme.pink},
  ];

  void _showAddTrackerDialog() {
    final customNameController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E2140),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, scrollCtrl) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Column(children: [
                Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(2))),
                const SizedBox(height: 14),
                const Text('Thêm bộ theo dõi mới', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
                const SizedBox(height: 14),
                // Custom name input
                TextField(
                  controller: customNameController,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Hoặc nhập tên bộ theo dõi tùy chỉnh...',
                    hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.08),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add_circle, color: AppTheme.accent),
                      onPressed: () {
                        final name = customNameController.text.trim();
                        if (name.isNotEmpty) {
                          setState(() {
                            _trackers.add({
                              'icon': Icons.track_changes, 'name': name,
                              'value': '---', 'status': 'Mới thêm', 'color': AppTheme.accent, 'fav': false,
                            });
                          });
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('✅ Đã thêm bộ theo dõi "$name"'),
                            backgroundColor: AppTheme.success,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ));
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text('Chọn từ danh sách bên dưới:', style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.5))),
              ]),
            ),
            Expanded(
              child: ListView.separated(
                controller: scrollCtrl,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _availableTrackers.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) {
                  final t = _availableTrackers[i];
                  final alreadyAdded = _trackers.any((tr) => tr['name'] == t['name']);
                  return GestureDetector(
                    onTap: alreadyAdded ? null : () {
                      setState(() => _trackers.add({...t, 'fav': false}));
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('✅ Đã thêm bộ theo dõi "${t['name']}"'),
                        backgroundColor: AppTheme.success,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: alreadyAdded ? 0.02 : 0.06),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                      ),
                      child: Row(children: [
                        Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            color: (t['color'] as Color).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(t['icon'], color: t['color'], size: 20),
                        ),
                        const SizedBox(width: 14),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t['name'], style: TextStyle(
                              color: Colors.white.withValues(alpha: alreadyAdded ? 0.4 : 0.9),
                              fontSize: 14, fontWeight: FontWeight.w500)),
                            Text(alreadyAdded ? 'Đã thêm' : t['status'],
                                style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 11)),
                          ],
                        )),
                        Icon(alreadyAdded ? Icons.check_circle : Icons.add_circle_outline,
                            color: alreadyAdded ? AppTheme.success : AppTheme.accent, size: 22),
                      ]),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.darkGradient),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Row(children: [
                const Text('Bộ theo dõi', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(children: [
                    Icon(Icons.star, color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text('Go Premium', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
                  ]),
                ),
              ]),
            ),
            // Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(children: [
                _tabBtn(0, 'Tất cả bộ theo dõi'),
                const SizedBox(width: 8),
                _tabBtn(1, 'Yêu thích'),
              ]),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Health Trackers
                    Text('Chỉ số sức khỏe', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.8))),
                    const SizedBox(height: 10),
                    ...(_selectedTab == 1
                        ? _trackers.where((t) => t['fav'] == true).toList()
                        : _trackers
                    ).map((t) => _trackerCard(t)),
                    const SizedBox(height: 20),

                    // Mood & Triggers
                    Text('Tâm trạng & Yếu tố kích hoạt', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.8))),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 90,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _moodTriggers.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (_, i) {
                          final m = _moodTriggers[i];
                          return Container(
                            width: 85,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: (m['color'] as Color).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: (m['color'] as Color).withValues(alpha: 0.2)),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(m['icon'], color: m['color'], size: 24),
                                const SizedBox(height: 6),
                                Text(m['name'], style: const TextStyle(color: Colors.white, fontSize: 10), textAlign: TextAlign.center),
                                Text('${m['count']} lần', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 9)),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Symptoms
                    Text('Triệu chứng theo dõi', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.8))),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8, runSpacing: 8,
                      children: _symptoms.map((s) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: (s['color'] as Color).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: (s['color'] as Color).withValues(alpha: 0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(s['name'], style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                              Text('${s['freq']} • ${s['severity']}', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 10)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // Special Trackers
                    Text('Bộ theo dõi đặc biệt', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.8))),
                    const SizedBox(height: 10),
                    ..._specialTrackers.map((t) => _specialTrackerItem(t)),
                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      child: Container(
                        decoration: BoxDecoration(gradient: AppTheme.primaryGradient, borderRadius: BorderRadius.circular(12)),
                        child: ElevatedButton.icon(
                          onPressed: _showAddTrackerDialog,
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Thêm bộ theo dõi mới'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabBtn(int index, String label) {
    final isActive = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primary : Colors.white.withValues(alpha: 0.06),
          border: Border.all(color: isActive ? AppTheme.primary : Colors.white.withValues(alpha: 0.1)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(label, style: TextStyle(fontSize: 13, color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.6))),
      ),
    );
  }

  Widget _trackerCard(Map<String, dynamic> tracker) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(children: [
        Container(
          width: 44, height: 44,
          decoration: BoxDecoration(
            color: (tracker['color'] as Color).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(tracker['icon'], color: tracker['color'], size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tracker['name'], style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(height: 2),
              Text(tracker['status'], style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 11)),
            ],
          ),
        ),
        Text(tracker['value'], style: TextStyle(color: tracker['color'], fontSize: 16, fontWeight: FontWeight.w700)),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            setState(() {
              final idx = _trackers.indexOf(tracker);
              _trackers[idx]['fav'] = !(tracker['fav'] as bool);
            });
          },
          child: Icon(tracker['fav'] ? Icons.favorite : Icons.favorite_border,
              color: tracker['fav'] ? AppTheme.danger : Colors.white.withValues(alpha: 0.3), size: 20),
        ),
      ]),
    );
  }

  Widget _specialTrackerItem(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(children: [
        Icon(item['icon'], color: AppTheme.accent, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item['name'], style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
              Text('Giới hạn: ${item['limit']}', style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 10)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(8)),
          child: Text(item['today'], style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
        ),
      ]),
    );
  }
}
