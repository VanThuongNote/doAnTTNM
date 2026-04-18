import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/logo.dart';

class StressScreen extends StatefulWidget {
  const StressScreen({super.key});

  @override
  State<StressScreen> createState() => _StressScreenState();
}

class _StressScreenState extends State<StressScreen> {
  int _stressLevel = 3;
  final List<String> _stressHistory = [
    'Hôm nay 10:30 - Mức 3: Trung bình',
    'Hôm qua 15:00 - Mức 5: Cao',
    'Hôm qua 08:00 - Mức 2: Thấp',
    '10/04 20:00 - Mức 4: Khá cao',
    '09/04 14:00 - Mức 1: Rất thấp',
  ];

  final List<String> _triggers = ['Công việc', 'Gia đình', 'Sức khỏe', 'Tài chính', 'Khác'];
  final Set<int> _selectedTriggers = {0};

  String get _stressLabel {
    if (_stressLevel <= 1) return 'Rất thấp';
    if (_stressLevel <= 2) return 'Thấp';
    if (_stressLevel <= 3) return 'Trung bình';
    if (_stressLevel <= 4) return 'Khá cao';
    return 'Cao';
  }

  Color get _stressColor {
    if (_stressLevel <= 2) return AppTheme.success;
    if (_stressLevel <= 3) return AppTheme.warning;
    return AppTheme.danger;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.darkGradient),
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stress level control
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.06),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          const Text('Mức độ căng thẳng hiện tại',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                          const SizedBox(height: 16),
                          Container(
                            width: 80, height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _stressColor.withValues(alpha: 0.2),
                              border: Border.all(color: _stressColor, width: 3),
                            ),
                            child: Center(
                              child: Text('$_stressLevel',
                                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: _stressColor)),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(_stressLabel,
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: _stressColor)),
                          const SizedBox(height: 16),
                          Slider(
                            value: _stressLevel.toDouble(),
                            min: 1, max: 5,
                            divisions: 4,
                            activeColor: _stressColor,
                            inactiveColor: Colors.white.withValues(alpha: 0.15),
                            onChanged: (v) => setState(() => _stressLevel = v.round()),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Thấp', style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.5))),
                              Text('Cao', style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.5))),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Triggers
                    const Text('Nguyên nhân căng thẳng',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8, runSpacing: 8,
                      children: List.generate(_triggers.length, (i) {
                        final isSelected = _selectedTriggers.contains(i);
                        return GestureDetector(
                          onTap: () => setState(() {
                            isSelected ? _selectedTriggers.remove(i) : _selectedTriggers.add(i);
                          }),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? _stressColor : Colors.white.withValues(alpha: 0.08),
                              border: Border.all(
                                  color: isSelected ? _stressColor : Colors.white.withValues(alpha: 0.2)),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(_triggers[i],
                                style: const TextStyle(color: Colors.white, fontSize: 13)),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 20),
                    // History
                    const Text('Lịch sử ghi nhận',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                    const SizedBox(height: 10),
                    ..._stressHistory.map((entry) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.access_time, color: Colors.white.withValues(alpha: 0.4), size: 16),
                          const SizedBox(width: 10),
                          Text(entry, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13)),
                        ],
                      ),
                    )),
                    const SizedBox(height: 20),
                    // Save button
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
                              content: const Text('✅ Đã ghi nhận mức căng thẳng'),
                              backgroundColor: AppTheme.success,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ));
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          child: const Text('Lưu'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
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
              const HealthTrackLogo(size: 28),
              const SizedBox(width: 10),
              const Text('Căng Thẳng',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
