import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  int _selectedTab = 0;
  final List<String> _tabs = ['Vận động', 'Giấc Ngủ', 'Tâm Trạng'];

  // Exercise data
  final List<Map<String, dynamic>> _exerciseData = [
    {'day': 'T2', 'steps': 8200, 'cal': 380, 'min': 45},
    {'day': 'T3', 'steps': 6500, 'cal': 290, 'min': 30},
    {'day': 'T4', 'steps': 9100, 'cal': 420, 'min': 55},
    {'day': 'T5', 'steps': 4300, 'cal': 210, 'min': 20},
    {'day': 'T6', 'steps': 7800, 'cal': 360, 'min': 40},
    {'day': 'T7', 'steps': 11000, 'cal': 520, 'min': 65},
    {'day': 'CN', 'steps': 6800, 'cal': 310, 'min': 35},
  ];

  // Sleep data
  final List<Map<String, dynamic>> _sleepData = [
    {'day': 'T2', 'hours': 7.5, 'quality': 'Tốt', 'color': AppTheme.success},
    {'day': 'T3', 'hours': 6.0, 'quality': 'TB', 'color': AppTheme.warning},
    {'day': 'T4', 'hours': 8.0, 'quality': 'Rất tốt', 'color': AppTheme.success},
    {'day': 'T5', 'hours': 5.5, 'quality': 'Kém', 'color': AppTheme.danger},
    {'day': 'T6', 'hours': 7.0, 'quality': 'Tốt', 'color': AppTheme.success},
    {'day': 'T7', 'hours': 8.5, 'quality': 'Rất tốt', 'color': AppTheme.success},
    {'day': 'CN', 'hours': 7.0, 'quality': 'Tốt', 'color': AppTheme.success},
  ];

  // Mood data
  final List<Map<String, dynamic>> _moodData = [
    {'day': 'T2', 'mood': '😊', 'label': 'Vui vẻ', 'score': 8},
    {'day': 'T3', 'mood': '😐', 'label': 'Bình thường', 'score': 5},
    {'day': 'T4', 'mood': '😄', 'label': 'Hạnh phúc', 'score': 9},
    {'day': 'T5', 'mood': '😞', 'label': 'Mệt mỏi', 'score': 3},
    {'day': 'T6', 'mood': '😊', 'label': 'Vui vẻ', 'score': 7},
    {'day': 'T7', 'mood': '😄', 'label': 'Tuyệt vời', 'score': 9},
    {'day': 'CN', 'mood': '🙂', 'label': 'Khá tốt', 'score': 6},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.darkGradient),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Text('Phân Tích Sức Khỏe', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
            ),
            // Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: List.generate(_tabs.length, (i) {
                  final isActive = _selectedTab == i;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: isActive ? AppTheme.primary : Colors.transparent,
                          border: Border.all(color: isActive ? AppTheme.primary : Colors.white.withValues(alpha: 0.2)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(_tabs[i], style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w500,
                          color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.6),
                        )),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Discovery card
                    _discoveryCard(),
                    const SizedBox(height: 16),
                    // Tab-specific content
                    _buildTabContent(),
                    const SizedBox(height: 16),
                    // AI Section
                    _aiSection(),
                    const SizedBox(height: 16),
                    // Action Plan
                    _actionPlan(),
                    const SizedBox(height: 16),
                    // Symptom forecast
                    _symptomForecast(),
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

  Widget _discoveryCard() {
    final discoveries = [
      'Chúng tôi nhận thấy đau đầu của bạn thường xuất hiện vào những ngày có áp suất khí quyển thấp. Hãy thử uống thêm nước vào những ngày này.',
      'Giấc ngủ của bạn cải thiện 20% khi tập thể dục buổi chiều. Hãy duy trì thói quen này.',
      'Tâm trạng có xu hướng tốt hơn vào cuối tuần. Stress công việc là tác nhân chính ảnh hưởng.',
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppTheme.primary.withValues(alpha: 0.15), AppTheme.accent.withValues(alpha: 0.1)]),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(children: [
            Icon(Icons.lightbulb, color: AppTheme.accent, size: 18),
            SizedBox(width: 6),
            Text('Khám phá mới', style: TextStyle(color: AppTheme.accent, fontSize: 14, fontWeight: FontWeight.w600)),
          ]),
          const SizedBox(height: 8),
          Text(discoveries[_selectedTab], style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13, height: 1.6)),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0:
        return _exerciseTab();
      case 1:
        return _sleepTab();
      case 2:
        return _moodTab();
      default:
        return const SizedBox();
    }
  }

  Widget _exerciseTab() {
    final totalSteps = _exerciseData.fold<int>(0, (sum, d) => sum + (d['steps'] as int));
    final avgSteps = totalSteps ~/ 7;
    final totalCal = _exerciseData.fold<int>(0, (sum, d) => sum + (d['cal'] as int));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Summary
        Row(children: [
          _summaryCard('🏃', 'TB Bước/ngày', '$avgSteps', AppTheme.accent),
          const SizedBox(width: 10),
          _summaryCard('🔥', 'Tổng Calo', '$totalCal kcal', AppTheme.orange),
        ]),
        const SizedBox(height: 12),
        // Bar chart
        Text('Bước chân 7 ngày qua', style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.6))),
        const SizedBox(height: 10),
        SizedBox(
          height: 120,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: _exerciseData.map((d) {
              final maxSteps = 11000;
              final height = ((d['steps'] as int) / maxSteps * 90).clamp(10.0, 90.0);
              return Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('${((d['steps'] as int) / 1000).toStringAsFixed(1)}k',
                        style: TextStyle(fontSize: 8, color: Colors.white.withValues(alpha: 0.5))),
                    const SizedBox(height: 4),
                    Container(
                      height: height, margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [AppTheme.accent, AppTheme.primary], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(d['day'], style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.5))),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),
        // Details
        ..._exerciseData.map((d) => Container(
          margin: const EdgeInsets.only(bottom: 6),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(children: [
            Text(d['day'], style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
            const Spacer(),
            Text('${d['steps']} bước', style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 11)),
            const SizedBox(width: 12),
            Text('${d['cal']} kcal', style: TextStyle(color: AppTheme.orange.withValues(alpha: 0.8), fontSize: 11)),
            const SizedBox(width: 12),
            Text('${d['min']} phút', style: TextStyle(color: AppTheme.success.withValues(alpha: 0.8), fontSize: 11)),
          ]),
        )),
      ],
    );
  }

  Widget _sleepTab() {
    final avgHours = _sleepData.fold<double>(0, (sum, d) => sum + (d['hours'] as double)) / 7;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          _summaryCard('😴', 'TB Giấc ngủ', '${avgHours.toStringAsFixed(1)}h', const Color(0xFF8B5CF6)),
          const SizedBox(width: 10),
          _summaryCard('⭐', 'Chất lượng', 'Tốt', AppTheme.success),
        ]),
        const SizedBox(height: 12),
        Text('Giấc ngủ 7 ngày qua', style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.6))),
        const SizedBox(height: 10),
        // Sleep bars
        SizedBox(
          height: 120,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: _sleepData.map((d) {
              final height = ((d['hours'] as double) / 10 * 90).clamp(10.0, 90.0);
              return Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('${d['hours']}h', style: TextStyle(fontSize: 8, color: Colors.white.withValues(alpha: 0.5))),
                    const SizedBox(height: 4),
                    Container(
                      height: height, margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: d['color'],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(d['day'], style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.5))),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),
        ..._sleepData.map((d) => Container(
          margin: const EdgeInsets.only(bottom: 6),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(children: [
            Text(d['day'], style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
            const Spacer(),
            Text('${d['hours']}h ngủ', style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 11)),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: (d['color'] as Color).withValues(alpha: 0.2), borderRadius: BorderRadius.circular(6)),
              child: Text(d['quality'], style: TextStyle(color: d['color'], fontSize: 10, fontWeight: FontWeight.w600)),
            ),
          ]),
        )),
      ],
    );
  }

  Widget _moodTab() {
    final avgScore = _moodData.fold<int>(0, (sum, d) => sum + (d['score'] as int)) / 7;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          _summaryCard('😊', 'TB Tâm trạng', '${avgScore.toStringAsFixed(1)}/10', AppTheme.accent),
          const SizedBox(width: 10),
          _summaryCard('📈', 'Xu hướng', 'Cải thiện', AppTheme.success),
        ]),
        const SizedBox(height: 12),
        Text('Tâm trạng 7 ngày qua', style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.6))),
        const SizedBox(height: 10),
        ..._moodData.map((d) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(children: [
            Text(d['mood'], style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(d['day'], style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                Text(d['label'], style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 11)),
              ],
            )),
            // Score bar
            SizedBox(
              width: 80,
              child: Column(children: [
                Row(children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (d['score'] as int) / 10,
                        backgroundColor: Colors.white.withValues(alpha: 0.1),
                        valueColor: AlwaysStoppedAnimation(
                          (d['score'] as int) >= 7 ? AppTheme.success :
                          (d['score'] as int) >= 5 ? AppTheme.warning : AppTheme.danger,
                        ),
                        minHeight: 6,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text('${d['score']}', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                ]),
              ]),
            ),
          ]),
        )),
      ],
    );
  }

  Widget _summaryCard(String emoji, String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text(emoji, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Text(label, style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.6))),
            ]),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _aiSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(children: [
          Icon(Icons.smart_toy, color: AppTheme.accent, size: 20),
          SizedBox(width: 8),
          Text('Gợi ý từ Health AI', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
        ]),
        const SizedBox(height: 12),
        _aiCard('Tối ưu hóa Vitamin D',
            'Dự báo ngày mai có nắng từ 8h-10h. Đây là thời điểm tốt nhất để bạn đi dạo và nạp năng lượng tự nhiên.'),
        const SizedBox(height: 10),
        _aiCard('Cải thiện chu kỳ ngủ',
            'Có dấu cho thấy bạn ngủ ngon hơn khi nhiệt độ phòng ở mức 22°C. Hãy thử điều chỉnh điều hòa tối nay.'),
        const SizedBox(height: 10),
        _aiCard('Giảm stress',
            'Mức stress tăng 30% trong tuần. Thử thiền 10 phút mỗi sáng để cải thiện tâm trạng và giảm đau đầu.'),
      ],
    );
  }

  Widget _aiCard(String title, String content) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: const Border(left: BorderSide(color: AppTheme.accent, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: AppTheme.accent, fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(content, style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12, height: 1.5)),
        ],
      ),
    );
  }

  Widget _actionPlan() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Kế hoạch hành động hôm nay', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        _planItem(Icons.check_circle, 'Uống 2.5L nước', AppTheme.success, true),
        _planItem(Icons.check_circle, 'Tập thể dục 30 phút buổi sáng', AppTheme.success, true),
        _planItem(Icons.radio_button_unchecked, 'Đi bộ 20 phút lúc 17:00 (Nắng nhẹ)', Colors.white.withValues(alpha: 0.3), false),
        _planItem(Icons.warning_amber, 'Tránh thực phẩm có tính acid cao', AppTheme.warning, false),
        _planItem(Icons.radio_button_unchecked, 'Thiền 10 phút trước khi ngủ', Colors.white.withValues(alpha: 0.3), false),
        _planItem(Icons.radio_button_unchecked, 'Ngủ trước 22:30 để hồi phục', Colors.white.withValues(alpha: 0.3), false),
      ],
    );
  }

  Widget _planItem(IconData icon, String text, Color iconColor, bool done) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: done ? 0.06 : 0.03),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(children: [
          Icon(icon, color: iconColor, size: 18),
          const SizedBox(width: 10),
          Flexible(child: Text(text, style: TextStyle(
            color: Colors.white.withValues(alpha: done ? 0.7 : 0.5), fontSize: 13,
            decoration: done ? TextDecoration.lineThrough : null,
          ))),
        ]),
      ),
    );
  }

  Widget _symptomForecast() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Dự báo triệu chứng', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Text('Nguy cơ đau đầu:', style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 13)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: AppTheme.warning.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                  child: const Text('Trung bình (45%)', style: TextStyle(color: AppTheme.warning, fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ]),
              const SizedBox(height: 8),
              Row(children: [
                Text('Nguy cơ mệt mỏi:', style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 13)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: AppTheme.danger.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                  child: const Text('Cao (70%)', style: TextStyle(color: AppTheme.danger, fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ]),
              const SizedBox(height: 8),
              Row(children: [
                Text('Nguy cơ mất ngủ:', style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 13)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: AppTheme.success.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                  child: const Text('Thấp (20%)', style: TextStyle(color: AppTheme.success, fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ]),
              const SizedBox(height: 6),
              Text('Yếu tố ảnh hưởng: Áp suất thấp + Thiếu ngủ + Stress', style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 11)),
            ],
          ),
        ),
      ],
    );
  }
}
