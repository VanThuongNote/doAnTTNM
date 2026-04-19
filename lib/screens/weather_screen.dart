import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/logo.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.headerGradient),
        child: Column(
          children: [
            // Header
            SafeArea(
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
                    const Text('Thời Tiết',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Current weather
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.wb_sunny, color: Colors.yellow, size: 60),
                          const SizedBox(height: 12),
                          const Text('TP. Hồ Chí Minh',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                          const SizedBox(height: 4),
                          const Text('32°C',
                              style: TextStyle(fontSize: 48, fontWeight: FontWeight.w800, color: Colors.white)),
                          Text('Nắng nhẹ • Cảm giác 35°C',
                              style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.7))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Weather details
                    Row(
                      children: [
                        _weatherDetail(Icons.water_drop, 'Độ ẩm', '75%'),
                        const SizedBox(width: 10),
                        _weatherDetail(Icons.air, 'Gió', '12 km/h'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _weatherDetail(Icons.speed, 'Áp suất', '1013 hPa'),
                        const SizedBox(width: 10),
                        _weatherDetail(Icons.visibility, 'Tầm nhìn', '10 km'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Weather alerts
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.cloud, color: Colors.white, size: 20),
                              SizedBox(width: 8),
                              Text('Lần mưa hoặc tuyết tiếp theo:',
                                  style: TextStyle(fontSize: 13, color: Colors.white)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text('không có sẵn',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white.withValues(alpha: 0.7))),
                          const SizedBox(height: 14),
                          const Row(
                            children: [
                              Icon(Icons.speed, color: Colors.white, size: 20),
                              SizedBox(width: 8),
                              Text('Áp suất khí quyển hiện tại',
                                  style: TextStyle(fontSize: 13, color: Colors.white)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text('1013 hPa - Bình thường',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Health impact
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppTheme.warning.withValues(alpha: 0.15), AppTheme.danger.withValues(alpha: 0.1)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.warning.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.warning_amber, color: AppTheme.warning, size: 18),
                              SizedBox(width: 8),
                              Text('Ảnh hưởng sức khỏe',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.warning)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '• Nhiệt độ cao, uống nhiều nước để tránh mất nước\n'
                            '• Áp suất ổn định, ít khả năng gây đau đầu\n'
                            '• Độ ẩm cao, chú ý về đường hô hấp',
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13, height: 1.6),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Forecast
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Dự báo 5 ngày',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                          const SizedBox(height: 12),
                          _forecastRow('Hôm nay', '☀️', '32°C', '26°C'),
                          _forecastRow('Thứ 2', '⛅', '30°C', '25°C'),
                          _forecastRow('Thứ 3', '🌧️', '28°C', '24°C'),
                          _forecastRow('Thứ 4', '🌤️', '31°C', '26°C'),
                          _forecastRow('Thứ 5', '☀️', '33°C', '27°C'),
                        ],
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

  static Widget _weatherDetail(IconData icon, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white.withValues(alpha: 0.7), size: 24),
            const SizedBox(height: 6),
            Text(label, style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.6))),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
          ],
        ),
      ),
    );
  }

  static Widget _forecastRow(String day, String icon, String high, String low) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 70, child: Text(day, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13))),
          Text(icon, style: const TextStyle(fontSize: 20)),
          const Spacer(),
          Text(high, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(width: 8),
          Text(low, style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 14)),
        ],
      ),
    );
  }
}

