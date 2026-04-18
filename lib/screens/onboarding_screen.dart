import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'welcome_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _step = 0;
  int _symptomCount = 0;
  int _selectedGender = -1;
  final Set<int> _selectedChips = {};
  final Set<int> _selectedTracking = {0}; // Cà phê selected by default

  // Reminder step state
  bool _dailyReminderEnabled = true;
  bool _medicineReminderEnabled = true;
  TimeOfDay _dailyReminderTime = const TimeOfDay(hour: 17, minute: 30);
  TimeOfDay _medicineReminderTime = const TimeOfDay(hour: 0, minute: 0);

  final List<String> _genderOptions = ['Nữ', 'Nam', 'Giới tính thứ 3', 'Thêm tuỳ chọn'];
  final List<String> _symptomChips = ['Đau đầu', 'Hoa mắt', 'Mệt mỏi', 'Chóng mặt', 'Ho,cảm', 'Nghẹt mũi'];
  final List<String> _trackingItems = ['Cà phê', 'Trà', 'chocolate', 'Bia', 'Rượu vang', 'Phô mai'];

  void _next() {
    if (_step >= 3) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const WelcomeScreen()));
    } else {
      setState(() => _step++);
    }
  }

  void _prev() {
    if (_step > 0) setState(() => _step--);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.darkGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Column(
              children: [
                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (_step + 1) / 4,
                    backgroundColor: Colors.white.withValues(alpha: 0.15),
                    valueColor: const AlwaysStoppedAnimation(AppTheme.accent),
                    minHeight: 4,
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (_) => const WelcomeScreen())),
                    child: Text('Bỏ qua',
                        style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.7))),
                  ),
                ),
                const SizedBox(height: 16),
                // Step content
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: _buildStep(),
                  ),
                ),
                // Navigation
                Row(
                  children: [
                    if (_step > 0)
                      Expanded(
                        flex: 3,
                        child: OutlinedButton(
                          onPressed: _step == 3 ? _next : _prev,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(color: Colors.white.withValues(alpha: 0.4)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(_step == 3 ? 'Nhắc tôi sau' : 'Trước',
                              style: const TextStyle(color: Colors.white, fontSize: 15)),
                        ),
                      ),
                    if (_step > 0) const SizedBox(width: 12),
                    Expanded(
                      flex: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ElevatedButton(
                          onPressed: _next,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          child: Text(_step == 3 ? 'Tiếp theo' : 'Tiếp theo'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return _step1();
      case 1:
        return _step2();
      case 2:
        return _step3();
      case 3:
        return _step4Reminder();
      default:
        return const SizedBox();
    }
  }

  Widget _step1() {
    return SingleChildScrollView(
      key: const ValueKey(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Giới thiệu',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
          const SizedBox(height: 8),
          Text('Tìm ra các tác nhân ảnh hưởng sẽ hiệu quả hơn khi chúng tôi hiểu rõ hơn về bạn.',
              style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.8))),
          const SizedBox(height: 24),
          const Text('Giới tính của bạn là gì?',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white)),
          const SizedBox(height: 10),
          ...List.generate(_genderOptions.length, (i) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: () => setState(() => _selectedGender = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: _selectedGender == i ? AppTheme.primary : Colors.white.withValues(alpha: 0.08),
                  border: Border.all(
                    color: _selectedGender == i ? AppTheme.primary : Colors.white.withValues(alpha: 0.15),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(_genderOptions[i],
                      style: const TextStyle(color: Colors.white, fontSize: 14)),
                ),
              ),
            ),
          )),
          const SizedBox(height: 16),
          const Text('Bạn sinh ngày bao nhiêu?',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white)),
          const SizedBox(height: 10),
          TextField(
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: '17, Tháng 3, Năm 2004',
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.08),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _step2() {
    return SingleChildScrollView(
      key: const ValueKey(1),
      child: Column(
        children: [
          const Text('Hãy cho chúng tôi biết về triệu chứng của bạn',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
              textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text('Khoảng bao nhiêu ngày mỗi tháng bạn có triệu chứng?',
              style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.8)),
              textAlign: TextAlign.center),
          const SizedBox(height: 20),
          // Counter
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _counterBtn(Icons.remove, AppTheme.primaryDark, () {
                if (_symptomCount > 0) setState(() => _symptomCount--);
              }),
              const SizedBox(width: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('$_symptomCount',
                    style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: Colors.white)),
              ),
              const SizedBox(width: 24),
              _counterBtn(Icons.add, AppTheme.success, () => setState(() => _symptomCount++)),
            ],
          ),
          const SizedBox(height: 12),
          Text('bạn có thể thêm sau',
              style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.6))),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(_symptomChips.length, (i) => GestureDetector(
              onTap: () => setState(() {
                _selectedChips.contains(i) ? _selectedChips.remove(i) : _selectedChips.add(i);
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: _selectedChips.contains(i) ? AppTheme.accent : Colors.white.withValues(alpha: 0.08),
                  border: Border.all(
                    color: _selectedChips.contains(i) ? AppTheme.accent : Colors.white.withValues(alpha: 0.2)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(_symptomChips[i], style: const TextStyle(color: Colors.white, fontSize: 13)),
              ),
            )),
          ),
          const SizedBox(height: 16),
          TextField(
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Hãy nhập thêm triệu chứng',
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.08),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _step3() {
    return SingleChildScrollView(
      key: const ValueKey(2),
      child: Column(
        children: [
          const Text('Danh sách theo dõi',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
          const SizedBox(height: 8),
          Text('Danh sách này bao gồm các tác nhân nghỉ ngờ phổ biến dựa trên hồ sơ của bạn',
              style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.8)),
              textAlign: TextAlign.center),
          const SizedBox(height: 20),
          ...List.generate(_trackingItems.length, (i) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: () => setState(() {
                _selectedTracking.contains(i) ? _selectedTracking.remove(i) : _selectedTracking.add(i);
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: _selectedTracking.contains(i) ? AppTheme.primary : Colors.white.withValues(alpha: 0.08),
                  border: Border.all(
                    color: _selectedTracking.contains(i) ? AppTheme.primary : Colors.white.withValues(alpha: 0.15)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(_trackingItems[i],
                      style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _counterBtn(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48, height: 48,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  // Step 4: Cảnh báo và nhắc nhở
  Widget _step4Reminder() {
    return SingleChildScrollView(
      key: const ValueKey(3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Cảnh báo và nhắc nhở',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
              textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text('Bạn có muốn nhận các thông báo từ\nứng dụng này không?',
              style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.8)),
              textAlign: TextAlign.center),
          const SizedBox(height: 24),
          // Nhắc nhở hàng ngày
          _reminderCard(
            title: 'Nhắc nhở hàng ngày',
            description: '"Đã đến lúc ghi lại các sự kiện trong ngày"',
            label: '"Nhắc tôi vào lúc"',
            time: _dailyReminderTime,
            enabled: _dailyReminderEnabled,
            onToggle: (v) => setState(() => _dailyReminderEnabled = v),
            onTimeTap: () async {
              final t = await showTimePicker(
                context: context,
                initialTime: _dailyReminderTime,
              );
              if (t != null) setState(() => _dailyReminderTime = t);
            },
          ),
          const SizedBox(height: 16),
          // Nhắc tôi uống thuốc
          _reminderCard(
            title: '"Nhắc tôi uống thuốc"',
            description: '',
            label: '"Nhắc tôi vào lúc"',
            time: _medicineReminderTime,
            enabled: _medicineReminderEnabled,
            onToggle: (v) => setState(() => _medicineReminderEnabled = v),
            onTimeTap: () async {
              final t = await showTimePicker(
                context: context,
                initialTime: _medicineReminderTime,
              );
              if (t != null) setState(() => _medicineReminderTime = t);
            },
          ),
        ],
      ),
    );
  }

  Widget _reminderCard({
    required String title,
    required String description,
    required String label,
    required TimeOfDay time,
    required bool enabled,
    required ValueChanged<bool> onToggle,
    required VoidCallback onTimeTap,
  }) {
    final timeStr = '${time.hour == 0 ? 12 : (time.hour > 12 ? time.hour - 12 : time.hour)}:${time.minute.toString().padLeft(2, '0')} ${time.hour >= 12 ? 'PM' : 'AM'}';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(title,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
              ),
              Switch(
                value: enabled,
                onChanged: onToggle,
                activeColor: AppTheme.accent,
                inactiveThumbColor: Colors.white.withValues(alpha: 0.5),
                inactiveTrackColor: Colors.white.withValues(alpha: 0.15),
              ),
            ],
          ),
          if (description.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(description,
                style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.6))),
          ],
          if (enabled) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Text(label,
                    style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.6))),
                const Spacer(),
                GestureDetector(
                  onTap: onTimeTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.accent.withValues(alpha: 0.5)),
                    ),
                    child: Text(timeStr,
                        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
