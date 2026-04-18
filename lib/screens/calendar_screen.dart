import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import 'sync_screen.dart';
import 'exercise_screen.dart';
import 'stress_screen.dart';
import 'notes_screen.dart';
import 'weather_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  int _selectedDate = 11;
  int _selectedCat = 1;
  int _selectedSubCat = 1;

  // Symptom data per day
  final Map<int, List<String>> _daySymptoms = {
    3: ['Đau đầu nhẹ'],
    7: ['Mệt mỏi', 'Đau đầu'],
    11: ['Ngủ tốt', 'Uống thuốc đúng giờ'],
    15: ['Chóng mặt', 'Buồn nôn'],
    20: ['Đau đầu nặng', 'Mất ngủ'],
    25: ['Khỏe mạnh', 'Tập gym'],
    27: ['Mệt mỏi nhẹ'],
  };

  final Map<int, Color> _dayColors = {
    3: AppTheme.warning,
    7: AppTheme.danger,
    11: AppTheme.success,
    15: AppTheme.danger,
    20: AppTheme.danger,
    25: AppTheme.success,
    27: AppTheme.warning,
  };

  final List<Map<String, dynamic>> _subCats = [
    {'icon': Icons.psychology, 'label': 'Tác nhân'},
    {'icon': Icons.favorite, 'label': 'Điều Trị'},
    {'icon': Icons.coronavirus, 'label': 'Triệu chứng'},
    {'icon': Icons.sync, 'label': 'Đồng bộ'},
  ];

  final List<Map<String, dynamic>> _treatments = [
    {'name': 'Paracetamol 500mg', 'time': '8:00 AM', 'status': 'Đã uống', 'color': AppTheme.success},
    {'name': 'Ibuprofen 200mg', 'time': '12:00 PM', 'status': 'Đã uống', 'color': AppTheme.success},
    {'name': 'Vitamin C 1000mg', 'time': '7:00 PM', 'status': 'Chưa uống', 'color': AppTheme.warning},
    {'name': 'Omega-3', 'time': '8:00 PM', 'status': 'Chưa uống', 'color': AppTheme.warning},
  ];

  final List<Map<String, dynamic>> _triggers = [
    {'name': 'Thời tiết thay đổi', 'impact': 'Cao', 'icon': Icons.cloud, 'color': AppTheme.danger},
    {'name': 'Thiếu ngủ', 'impact': 'Cao', 'icon': Icons.bedtime, 'color': AppTheme.warning},
    {'name': 'Stress công việc', 'impact': 'Trung bình', 'icon': Icons.work, 'color': AppTheme.orange},
    {'name': 'Thức ăn nhiều dầu mỡ', 'impact': 'Thấp', 'icon': Icons.restaurant, 'color': AppTheme.accent},
    {'name': 'Uống cà phê quá nhiều', 'impact': 'Trung bình', 'icon': Icons.coffee, 'color': AppTheme.warning},
  ];

  final List<Map<String, dynamic>> _actionItems = [
    {'icon': Icons.emoji_emotions, 'label': 'Cảm xúc', 'value': 'Vui vẻ ☺️'},
    {'icon': Icons.sticky_note_2, 'label': 'Ghi chú', 'value': '3 ghi chú'},
    {'icon': Icons.cloud, 'label': 'Thời Tiết', 'value': '32°C ☀️'},
    {'icon': Icons.fitness_center, 'label': 'Luyện tập', 'value': '30 phút'},
  ];

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
                const Text('Theo dõi', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
                const Spacer(),
                GestureDetector(
                  onTap: _showUploadDialog,
                  child: _headerBtn(Icons.file_upload_outlined),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _showListDialog,
                  child: _headerBtn(Icons.list),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _copyData,
                  child: _headerBtn(Icons.copy),
                ),
              ]),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Filter
                    Row(children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(20)),
                        child: const Text('Tất cả các tập', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text('✅ Đã thêm tập theo dõi mới'),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ));
                        },
                        child: Container(
                          width: 32, height: 32,
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: AppTheme.success),
                          child: const Icon(Icons.add, color: Colors.white, size: 18),
                        ),
                      ),
                    ]),
                    const SizedBox(height: 16),
                    // Month header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Icon(Icons.chevron_left, color: Colors.white.withValues(alpha: 0.7)),
                        ),
                        const Text('Tháng 4 2026', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                        GestureDetector(
                          onTap: () {},
                          child: Icon(Icons.chevron_right, color: Colors.white.withValues(alpha: 0.7)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Calendar grid
                    _buildCalendarGrid(),
                    const SizedBox(height: 12),
                    // Selected day info
                    if (_daySymptoms.containsKey(_selectedDate))
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: (_dayColors[_selectedDate] ?? AppTheme.accent).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: (_dayColors[_selectedDate] ?? AppTheme.accent).withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Ngày $_selectedDate/4/2026', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            ..._daySymptoms[_selectedDate]!.map((s) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(children: [
                                Container(width: 6, height: 6, decoration: BoxDecoration(shape: BoxShape.circle, color: _dayColors[_selectedDate])),
                                const SizedBox(width: 8),
                                Text(s, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12)),
                              ]),
                            )),
                          ],
                        ),
                      ),
                    const SizedBox(height: 16),
                    // Sub categories
                    SizedBox(
                      height: 44,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _subCats.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, i) {
                          final isActive = _selectedSubCat == i;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedSubCat = i),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                color: isActive ? AppTheme.primary : Colors.white.withValues(alpha: 0.06),
                                border: Border.all(color: isActive ? AppTheme.primary : Colors.white.withValues(alpha: 0.1)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(children: [
                                Icon(_subCats[i]['icon'], size: 16, color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.6)),
                                const SizedBox(width: 6),
                                Text(_subCats[i]['label'], style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500,
                                    color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.6))),
                              ]),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Content based on selected sub category
                    _buildSubCatContent(),
                    const SizedBox(height: 16),
                    // Action grid
                    GridView.count(
                      crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 2.5,
                      children: [
                        _actionGridItem(Icons.self_improvement, 'Căng Thẳng', 'Mức 3', () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const StressScreen()));
                        }),
                        _actionGridItem(Icons.sticky_note_2, 'Ghi chú', '3 ghi chú', () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const NotesScreen()));
                        }),
                        _actionGridItem(Icons.cloud, 'Thời Tiết', '32°C ☀️', () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const WeatherScreen()));
                        }),
                        _actionGridItem(Icons.fitness_center, 'Luyện tập', '30 phút', () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const ExerciseScreen()));
                        }),
                      ],
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

  Widget _buildSubCatContent() {
    switch (_selectedSubCat) {
      case 0: // Tác nhân
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tác nhân gây triệu chứng', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.8))),
            const SizedBox(height: 10),
            ..._triggers.map((t) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(10),
                border: Border(left: BorderSide(color: t['color'], width: 3)),
              ),
              child: Row(children: [
                Icon(t['icon'], color: t['color'], size: 20),
                const SizedBox(width: 10),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t['name'], style: const TextStyle(color: Colors.white, fontSize: 13)),
                    Text('Mức ảnh hưởng: ${t['impact']}', style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 10)),
                  ],
                )),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: (t['color'] as Color).withValues(alpha: 0.2), borderRadius: BorderRadius.circular(6)),
                  child: Text(t['impact'], style: TextStyle(color: t['color'], fontSize: 10, fontWeight: FontWeight.w600)),
                ),
              ]),
            )),
          ],
        );
      case 1: // Điều Trị
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Lịch uống thuốc hôm nay', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.8))),
            const SizedBox(height: 10),
            ..._treatments.map((t) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(children: [
                Container(
                  width: 8, height: 8,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: t['color']),
                ),
                const SizedBox(width: 10),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t['name'], style: const TextStyle(color: Colors.white, fontSize: 13)),
                    Text(t['time'], style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 10)),
                  ],
                )),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: (t['color'] as Color).withValues(alpha: 0.2), borderRadius: BorderRadius.circular(6)),
                  child: Text(t['status'], style: TextStyle(color: t['color'], fontSize: 10, fontWeight: FontWeight.w600)),
                ),
              ]),
            )),
          ],
        );
      case 2: // Triệu chứng
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Triệu chứng đang theo dõi', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.8))),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8, runSpacing: 8,
                children: ['Đau đầu', 'Mệt mỏi', 'Mất ngủ', 'Chóng mặt', 'Đau bụng'].map((s) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.accent.withValues(alpha: 0.3)),
                  ),
                  child: Text(s, style: const TextStyle(color: Colors.white, fontSize: 12)),
                )).toList(),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text('5 triệu chứng đang được theo dõi',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12)),
              ),
            ],
          ),
        );
      case 3: // Đồng bộ
        return GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const SyncScreen()));
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Container(
                  width: 60, height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.primary.withValues(alpha: 0.2),
                  ),
                  child: const Icon(Icons.sync, color: AppTheme.accent, size: 30),
                ),
                const SizedBox(height: 12),
                const Text('Đồng bộ dữ liệu',
                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text('Lần đồng bộ cuối: 11/04/2026 18:30',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text('Mở Đồng bộ',
                      style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildCalendarGrid() {
    final headers = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];
    final days = [
      [0, 0, 1, 2, 3, 4, 5],
      [6, 7, 8, 9, 10, 11, 12],
      [13, 14, 15, 16, 17, 18, 19],
      [20, 21, 22, 23, 24, 25, 26],
      [27, 28, 29, 30, 0, 0, 0],
    ];

    return Column(
      children: [
        Row(
          children: headers.map((h) => Expanded(
            child: Center(child: Text(h, style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.5), fontWeight: FontWeight.w500))),
          )).toList(),
        ),
        const SizedBox(height: 4),
        ...days.map((week) => Row(
          children: week.map((day) => Expanded(
            child: GestureDetector(
              onTap: day > 0 ? () => setState(() => _selectedDate = day) : null,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: _selectedDate == day ? AppTheme.primary :
                         _dayColors.containsKey(day) ? _dayColors[day]!.withValues(alpha: 0.15) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: _dayColors.containsKey(day) && _selectedDate != day
                      ? Border.all(color: _dayColors[day]!.withValues(alpha: 0.3), width: 1)
                      : null,
                ),
                child: Center(
                  child: Text(
                    day > 0 ? '$day' : '',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: _selectedDate == day ? FontWeight.w600 : FontWeight.w400,
                      color: _selectedDate == day ? Colors.white : Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ),
            ),
          )).toList(),
        )),
      ],
    );
  }

  void _showUploadDialog() {
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
            const Text('Tải lên tệp', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            _uploadItem(Icons.insert_drive_file, 'Tệp PDF báo cáo sức khỏe', '.pdf', () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text('📄 Đang tải lên tệp PDF...'),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ));
            }),
            _uploadItem(Icons.image, 'Ảnh chụp đơn thuốc', '.jpg, .png', () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text('🖼️ Đang tải lên ảnh đơn thuốc...'),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ));
            }),
            _uploadItem(Icons.table_chart, 'Tệp CSV dữ liệu sức khỏe', '.csv, .xlsx', () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text('📊 Đang tải lên dữ liệu sức khỏe...'),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ));
            }),
          ],
        ),
      ),
    );
  }

  Widget _uploadItem(IconData icon, String title, String ext, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: AppTheme.accent.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: AppTheme.accent, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
              Text(ext, style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 11)),
            ],
          )),
          Icon(Icons.upload_file, color: Colors.white.withValues(alpha: 0.4), size: 20),
        ]),
      ),
    );
  }

  void _showListDialog() {
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
            const Text('Tổng quan theo dõi', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            _listItem('📅', 'Ngày theo dõi', '30 ngày', AppTheme.accent),
            _listItem('💊', 'Thuốc đã uống', '85 lần', AppTheme.success),
            _listItem('🤒', 'Triệu chứng ghi nhận', '24 lần', AppTheme.warning),
            _listItem('🏃', 'TB bước chân/ngày', '7,671', AppTheme.primary),
            _listItem('😴', 'TB giấc ngủ/đêm', '7.1h', const Color(0xFF8B5CF6)),
            _listItem('💧', 'TB nước/ngày', '1.8L', AppTheme.accent),
          ],
        ),
      ),
    );
  }

  Widget _listItem(String emoji, String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 14))),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
          child: Text(value, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600)),
        ),
      ]),
    );
  }

  void _copyData() {
    final buffer = StringBuffer();
    buffer.writeln('=== HEALTHTRACK - BÁO CÁO THEO DÕI ===');
    buffer.writeln('Tháng 4/2026\n');
    buffer.writeln('--- DỮ LIỆU TRIỆU CHỨNG ---');
    _daySymptoms.forEach((day, symptoms) {
      buffer.writeln('Ngày $day/4: ${symptoms.join(", ")}');
    });
    buffer.writeln('\n--- THUỐC ĐANG DÙNG ---');
    for (var t in _treatments) {
      buffer.writeln('${t['name']} - ${t['time']} (${t['status']})');
    }
    buffer.writeln('\n--- TÁC NHÂN ---');
    for (var t in _triggers) {
      buffer.writeln('${t['name']} - Mức ảnh hưởng: ${t['impact']}');
    }
    Clipboard.setData(ClipboardData(text: buffer.toString()));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('📋 Đã sao chép dữ liệu theo dõi vào bộ nhớ tạm'),
      backgroundColor: AppTheme.success,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      duration: const Duration(seconds: 2),
    ));
  }

  Widget _headerBtn(IconData icon) {
    return Container(
      width: 36, height: 36,
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
      child: Icon(icon, color: Colors.white, size: 18),
    );
  }

  Widget _actionGridItem(IconData icon, String label, String value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(children: [
              Icon(icon, color: AppTheme.accent, size: 16),
              const SizedBox(width: 6),
              Text(label, style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.6))),
            ]),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
