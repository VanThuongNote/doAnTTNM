import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/logo.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  int _selectedDay = 3; // Default Thứ 4
  final List<String> _days = ['Chủ Nhật', 'Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7'];

  // Medicine management - per day
  final Map<int, List<String>> _medicinesByDay = {
    0: ['Vitamin C', 'Omega-3'],
    1: ['Paracetamol', 'Ibuprofen', 'Vitamin C'],
    2: ['Ibuprofen', 'Omega-3'],
    3: ['Codein', 'Loperamide', 'Paradon'],
    4: ['Paracetamol', 'Ibuprofen', 'Vitamin C'],
    5: ['Vitamin C'],
    6: ['Vitamin C', 'Omega-3'],
  };

  // Pain tracking per day
  final Map<int, Set<int>> _painsByDay = {
    0: {},
    1: {0, 2},
    2: {1},
    3: {0, 1},
    4: {0, 1, 2},
    5: {},
    6: {0},
  };

  // Diary entries per day
  final Map<int, List<String>> _entriesByDay = {
    0: ['Nghỉ ngơi cả ngày', 'Đi dạo buổi sáng 20 phút'],
    1: ['Uống thuốc hạ sốt lúc 8:00', 'Đau đầu nhẹ từ 14:00 - 15:30'],
    2: ['Ngủ dậy muộn, mệt mỏi nhẹ', 'Họp online 3 tiếng'],
    3: ['Tập gym 45 phút', 'Ăn salad trưa', 'Cảm thấy năng lượng tốt'],
    4: ['Đau đầu nặng buổi sáng', 'Nghỉ ở nhà'],
    5: ['Chạy bộ 5km buổi sáng', 'Yoga 20 phút'],
    6: ['Đi leo núi cùng bạn bè', 'Ăn BBQ buổi tối'],
  };

  // Status per day
  final Map<int, Map<String, dynamic>> _statusByDay = {
    0: {'label': 'Khỏe mạnh', 'color': AppTheme.success, 'time': '8:00 AM'},
    1: {'label': 'Đau đầu nhẹ', 'color': AppTheme.warning, 'time': '2:55 PM'},
    2: {'label': 'Mệt mỏi', 'color': AppTheme.warning, 'time': '10:30 AM'},
    3: {'label': 'Tốt', 'color': AppTheme.success, 'time': '2:55 PM'},
    4: {'label': 'Không tốt', 'color': AppTheme.danger, 'time': '7:00 AM'},
    5: {'label': 'Rất tốt', 'color': AppTheme.success, 'time': '6:30 AM'},
    6: {'label': 'Tốt', 'color': AppTheme.success, 'time': '9:00 AM'},
  };

  final List<String> _painOptions = ['Đau bụng', 'Buồn nôn', 'Tiêu chảy'];
  final TextEditingController _medController = TextEditingController();
  final TextEditingController _entryController = TextEditingController();

  List<String> get _currentMedicines => _medicinesByDay[_selectedDay] ?? [];
  Set<int> get _currentPains => _painsByDay[_selectedDay] ?? {};
  List<String> get _currentEntries => _entriesByDay[_selectedDay] ?? [];
  Map<String, dynamic> get _currentStatus => _statusByDay[_selectedDay] ?? {'label': '---', 'color': AppTheme.textMuted, 'time': '---'};

  @override
  void dispose() {
    _medController.dispose();
    _entryController.dispose();
    super.dispose();
  }

  void _prevDay() {
    if (_selectedDay > 0) setState(() => _selectedDay--);
  }

  void _nextDay() {
    if (_selectedDay < 6) setState(() => _selectedDay++);
  }

  void _showAddMedicineDialog() {
    _medController.clear();
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A2560),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(24, 16, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle
                  Container(
                    width: 40, height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Thêm thuốc',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white)),
                      GestureDetector(
                        onTap: () => Navigator.pop(ctx),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('Đóng',
                              style: TextStyle(fontSize: 13, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Drug name input
                  TextField(
                    controller: _medController,
                    autofocus: true,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    decoration: InputDecoration(
                      hintText: 'Nhập tên thuốc...',
                      hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.08),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Quick add suggestions
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Gợi ý nhanh:', style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.5))),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8, runSpacing: 8,
                    children: ['Thuốc hạ sốt', 'Thuốc đau đầu', 'Thuốc ho', 'Vitamin C', 'Paracetamol'].map((name) {
                      return GestureDetector(
                        onTap: () {
                          setModalState(() {
                            _medController.text = name;
                            _medController.selection = TextSelection.fromPosition(
                              TextPosition(offset: name.length),
                            );
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8A87C).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE8A87C).withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.medication, color: Color(0xFFE8A87C), size: 16),
                              const SizedBox(width: 6),
                              Text(name, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  // Add button
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          final name = _medController.text.trim();
                          if (name.isNotEmpty) {
                            setState(() {
                              _medicinesByDay[_selectedDay] ??= [];
                              _medicinesByDay[_selectedDay]!.add(name);
                            });
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('✅ Đã thêm thuốc "$name" vào ${_days[_selectedDay]}'),
                              backgroundColor: AppTheme.success,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Thêm', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showAddEntryDialog() {
    _entryController.clear();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E2140),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Thêm ghi chú nhật ký', style: TextStyle(color: Colors.white, fontSize: 16)),
        content: TextField(
          controller: _entryController,
          autofocus: true,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Nhập ghi chú...',
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.08),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Hủy', style: TextStyle(color: Colors.white.withValues(alpha: 0.6))),
          ),
          ElevatedButton(
            onPressed: () {
              final text = _entryController.text.trim();
              if (text.isNotEmpty) {
                setState(() {
                  _entriesByDay[_selectedDay] ??= [];
                  _entriesByDay[_selectedDay]!.add(text);
                });
                Navigator.pop(ctx);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary),
            child: const Text('Thêm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final status = _currentStatus;
    final now = DateTime.now();
    final dateStr = 'Thg ${now.month} ${now.day}';

    return Scaffold(
      body: Container(
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
                  child: Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 36, height: 36,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const HealthTrackLogo(size: 28),
                          const SizedBox(width: 8),
                          const Text('HealthTrack',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('👤 Đang xem nhật ký ${_days[_selectedDay]}'),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ));
                            },
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.white.withValues(alpha: 0.3),
                              child: const Icon(Icons.person, color: Colors.white, size: 22),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 36,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _days.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 6),
                          itemBuilder: (context, i) {
                            final isActive = _selectedDay == i;
                            final shortDay = i == 0 ? 'CN' : 'Thứ ${i + 1}';
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
                                child: Text(shortDay,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                                      color: isActive ? AppTheme.primary : Colors.white.withValues(alpha: 0.7),
                                    )),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Day title with arrows
                    Row(
                      children: [
                        Expanded(
                          child: Text('Nhật ký ${_days[_selectedDay]}',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                        ),
                        GestureDetector(
                          onTap: _prevDay,
                          child: Container(
                            width: 32, height: 32,
                            decoration: BoxDecoration(
                              color: _selectedDay > 0 ? Colors.white.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.04),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.chevron_left,
                              color: _selectedDay > 0 ? Colors.white : Colors.white.withValues(alpha: 0.2), size: 22),
                          ),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: _nextDay,
                          child: Container(
                            width: 32, height: 32,
                            decoration: BoxDecoration(
                              color: _selectedDay < 6 ? Colors.white.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.04),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.chevron_right,
                              color: _selectedDay < 6 ? Colors.white : Colors.white.withValues(alpha: 0.2), size: 22),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Diary entries card
                    if (_currentEntries.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.06),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.edit_note, color: AppTheme.accent, size: 18),
                                const SizedBox(width: 6),
                                Text('Ghi chú ${_days[_selectedDay]}',
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.8))),
                                const Spacer(),
                                GestureDetector(
                                  onTap: _showAddEntryDialog,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppTheme.accent.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.add, color: AppTheme.accent, size: 14),
                                        SizedBox(width: 2),
                                        Text('Thêm', style: TextStyle(color: AppTheme.accent, fontSize: 11)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            ...List.generate(_currentEntries.length, (i) => Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${i + 1}. ', style: TextStyle(fontSize: 13, color: AppTheme.accent, fontWeight: FontWeight.w600)),
                                  Expanded(child: Text(_currentEntries[i],
                                      style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.7)))),
                                ],
                              ),
                            )),
                          ],
                        ),
                      ),

                    // Status bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [status['color'] as Color, AppTheme.accent]),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(children: [
                        Container(width: 10, height: 10,
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white)),
                        const SizedBox(width: 8),
                        Expanded(child: Text('Tình trạng: ${status['label']}',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white))),
                        Text(status['time'], style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.8))),
                      ]),
                    ),

                    // Treatment card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.06),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Thêm vào nhật ký',
                              style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.6))),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _tag('Điều trị', true),
                              const SizedBox(width: 8),
                              _tag(dateStr, false),
                              const SizedBox(width: 8),
                              _tag(status['time'], false),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text('Ghi lại loại thuốc',
                              style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.6))),
                          const SizedBox(height: 10),
                          // Medicine chips
                          if (_currentMedicines.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Center(
                                child: Text('Chưa có thuốc nào cho ${_days[_selectedDay]}',
                                    style: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 13)),
                              ),
                            )
                          else
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _currentMedicines.map((med) {
                                return GestureDetector(
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text('💊 $med - Nhấn giữ để xóa'),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      duration: const Duration(seconds: 1),
                                    ));
                                  },
                                  onLongPress: () {
                                    setState(() => _medicinesByDay[_selectedDay]?.remove(med));
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text('🗑️ Đã xóa "$med"'),
                                      backgroundColor: AppTheme.danger,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.08),
                                      border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(med,
                                        style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
                                  ),
                                );
                              }).toList(),
                            ),
                          const SizedBox(height: 24),
                          // Clipboard icon
                          Center(
                            child: GestureDetector(
                              onTap: _showAddMedicineDialog,
                              child: Container(
                                width: 80, height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: 0.06),
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                                ),
                                child: Icon(Icons.content_paste, color: Colors.white.withValues(alpha: 0.4), size: 36),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // "Thêm loại thuốc" link
                          Center(
                            child: GestureDetector(
                              onTap: _showAddMedicineDialog,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: const Color(0xFFE8A87C).withValues(alpha: 0.5)),
                                ),
                                child: const Text('Thêm loại thuốc',
                                    style: TextStyle(color: Color(0xFFE8A87C), fontSize: 16, fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Pain tracking section
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.06),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text('Ghi lại con đau',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                              const Spacer(),
                              Text('${_currentPains.length}/${_painOptions.length} đã chọn',
                                  style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.4))),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: List.generate(_painOptions.length, (i) {
                              final selected = _currentPains.contains(i);
                              return GestureDetector(
                                onTap: () => setState(() {
                                  _painsByDay[_selectedDay] ??= {};
                                  if (selected) {
                                    _painsByDay[_selectedDay]!.remove(i);
                                  } else {
                                    _painsByDay[_selectedDay]!.add(i);
                                  }
                                }),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: selected ? AppTheme.accent : Colors.white.withValues(alpha: 0.08),
                                    border: Border.all(
                                      color: selected ? AppTheme.accent : Colors.white.withValues(alpha: 0.2)),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(_painOptions[i],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                                      )),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Tiếp tục button
                    SizedBox(
                      width: double.infinity,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('✅ Đã lưu nhật ký ${_days[_selectedDay]}'),
                              backgroundColor: AppTheme.success,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ));
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Tiếp tục', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
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

  Widget _tag(String text, bool active) {
    return GestureDetector(
      onTap: () {
        if (active) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('📋 Loại: Điều trị'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            duration: const Duration(seconds: 1),
          ));
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppTheme.primary : Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(text,
            style: TextStyle(fontSize: 12, color: active ? Colors.white : Colors.white.withValues(alpha: 0.7))),
      ),
    );
  }
}
