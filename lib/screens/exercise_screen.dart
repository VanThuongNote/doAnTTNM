import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/logo.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key});

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  int _intensity = 5;
  int _selectedTimeSlot = 2; // default "Mở"
  final Set<int> _selectedSymptoms = {0};
  String _startTime = '';

  final List<Map<String, dynamic>> _startTimes = [
    {'label': 'Thứ Tư, 23 Tháng 4  19:00'},
    {'label': 'Thứ Năm, 24 Tháng 4  20:05'},
    {'label': 'Thứ Bảy, 26 Tháng 4  22:15'},
    {'label': 'Chủ Nhật, 27 Tháng 4  23:20'},
  ];

  final List<String> _timeSlots = [
    'Nửa giờ/trước', 'Sáng', 'Mở', 'Chiều', 'Tối', 'Muộn'
  ];

  final List<String> _symptomOptions = [
    'Mất ngủ', 'Buồn nôn', 'Mất ngủ'
  ];

  String get _intensityLabel {
    if (_intensity <= 1) return 'rất nhẹ';
    if (_intensity <= 2) return 'nhẹ';
    if (_intensity <= 3) return 'vừa phải';
    if (_intensity <= 4) return 'khá mạnh';
    if (_intensity <= 5) return 'dữ dội';
    if (_intensity <= 6) return 'rất dữ dội';
    if (_intensity <= 7) return 'cực đoan';
    return 'tối đa';
  }

  @override
  Widget build(BuildContext context) {
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
                  child: Row(
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
                      Container(width: 36, height: 36, decoration: BoxDecoration(gradient: AppTheme.primaryGradient, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.monitor_heart, color: Colors.white, size: 20)),
                      const SizedBox(width: 10),
                      const Text('HealthTrack',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
                      const Spacer(),
                      const Text('Tập mới',
                          style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500)),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Chọn thời điểm bắt đầu
                    _buildStartTimeSection(),
                    const SizedBox(height: 20),
                    // Time slots
                    _buildTimeSlotsSection(),
                    const SizedBox(height: 20),
                    // Thêm / Kết thúc
                    _buildEndTimeSection(),
                    const SizedBox(height: 20),
                    // Cường độ tổng thể
                    _buildIntensitySection(),
                    const SizedBox(height: 20),
                    // Bản đồ đau
                    _buildPainMapSection(),
                    const SizedBox(height: 20),
                    // Triệu chứng
                    _buildSymptomsSection(),
                    const SizedBox(height: 24),
                    // Buttons
                    _buildActionButtons(),
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

  Widget _buildStartTimeSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text('Chọn thời điểm bắt đầu',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
          const SizedBox(height: 14),
          ...List.generate(_startTimes.length, (i) {
            final isSelected = _startTime == _startTimes[i]['label'];
            return GestureDetector(
              onTap: () => setState(() => _startTime = _startTimes[i]['label']),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primary.withValues(alpha: 0.3)
                      : Colors.white.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(10),
                  border: isSelected
                      ? Border.all(color: AppTheme.accent, width: 1.5)
                      : null,
                ),
                child: Text(
                  _startTimes[i]['label'],
                  style: TextStyle(
                    fontSize: 14,
                    color: isSelected ? AppTheme.accent : Colors.white.withValues(alpha: 0.7),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTimeSlotsSection() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(_timeSlots.length, (i) {
        final isSelected = _selectedTimeSlot == i;
        return GestureDetector(
          onTap: () => setState(() => _selectedTimeSlot = i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.accent : Colors.white.withValues(alpha: 0.08),
              border: Border.all(
                  color: isSelected ? AppTheme.accent : Colors.white.withValues(alpha: 0.2)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(_timeSlots[i],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                )),
          ),
        );
      }),
    );
  }

  Widget _buildEndTimeSection() {
    return Container(
      padding: const EdgeInsets.all(16),
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
              Text('Thêm:', style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.6))),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('Không xác định',
                    style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text('Kết thúc:', style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.6))),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text('⏰ Chọn thời gian kết thúc'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ));
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                  ),
                  child: Text('Thêm thời gian sắt thuốc',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIntensitySection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text('Cường độ tổng thể',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
          const SizedBox(height: 6),
          Text('Mức độ $_intensity: $_intensityLabel',
              style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.7))),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  if (_intensity > 1) setState(() => _intensity--);
                },
                child: Container(
                  width: 44, height: 44,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.primaryDark,
                  ),
                  child: const Icon(Icons.remove, color: Colors.white, size: 22),
                ),
              ),
              const SizedBox(width: 20),
              Container(
                width: 60, height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.accent,
                      _intensity > 5 ? AppTheme.danger : AppTheme.primary,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.accent.withValues(alpha: 0.4),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Center(
                  child: Text('$_intensity',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white)),
                ),
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  if (_intensity < 10) setState(() => _intensity++);
                },
                child: Container(
                  width: 44, height: 44,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.success,
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 22),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPainMapSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.map_outlined, color: Colors.white.withValues(alpha: 0.6), size: 18),
              const SizedBox(width: 8),
              Text('Bản đồ đau',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white.withValues(alpha: 0.8))),
              const Spacer(),
              Text('(tùy chọn)',
                  style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.4))),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Human body icon
              Container(
                width: 80, height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.accessibility_new, color: Colors.white.withValues(alpha: 0.4), size: 60),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text('🎯 Nhấn vào vị trí đau trên bản đồ cơ thể'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ));
                },
                child: Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.accent.withValues(alpha: 0.2),
                    border: Border.all(color: AppTheme.accent, width: 2),
                  ),
                  child: const Icon(Icons.add, color: AppTheme.accent, size: 24),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSymptomsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Triệu chứng',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
          Text('Thêm các triệu chứng không đau\n(tùy chọn)',
              style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.5))),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...List.generate(_symptomOptions.length, (i) {
                final isSelected = _selectedSymptoms.contains(i);
                return GestureDetector(
                  onTap: () => setState(() {
                    isSelected ? _selectedSymptoms.remove(i) : _selectedSymptoms.add(i);
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.accent : Colors.white.withValues(alpha: 0.08),
                      border: Border.all(
                          color: isSelected ? AppTheme.accent : Colors.white.withValues(alpha: 0.2)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(_symptomOptions[i],
                        style: const TextStyle(color: Colors.white, fontSize: 13)),
                  ),
                );
              }),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text('➕ Thêm triệu chứng mới'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ));
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: AppTheme.accent.withValues(alpha: 0.5)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, color: AppTheme.accent, size: 16),
                      SizedBox(width: 4),
                      Text('Triệu chứng mới',
                          style: TextStyle(color: AppTheme.accent, fontSize: 13)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
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
                  content: const Text('✅ Đã thêm vào nhật ký!'),
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
              child: const Text('Thêm vào nhật ký',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text('➡️ Tiếp tục...'),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ));
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Tiếp tục',
                style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
          ),
        ),
      ],
    );
  }
}

