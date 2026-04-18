import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/logo.dart';

class SyncScreen extends StatefulWidget {
  const SyncScreen({super.key});

  @override
  State<SyncScreen> createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {
  int _syncState = 0; // 0: initial, 1: connecting, 2: connected

  void _syncWithApp() {
    setState(() => _syncState = 1);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _syncState = 2);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('✅ Đồng bộ với ứng dụng thành công!'),
          backgroundColor: AppTheme.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ));
      }
    });
  }

  void _syncWithDevice() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF252A5E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primary.withValues(alpha: 0.2),
              ),
              child: const Icon(Icons.bluetooth_searching, color: AppTheme.accent, size: 40),
            ),
            const SizedBox(height: 20),
            const Text('Chấp nhận kết nối',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
            const SizedBox(height: 8),
            Text('Đang tìm kiếm thiết bị...',
                style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.6))),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Hủy', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _showConnectedDialog();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      child: const Text('Kết nối'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showConnectedDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF252A5E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.success.withValues(alpha: 0.2),
              ),
              child: const Icon(Icons.check_circle, color: AppTheme.success, size: 50),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: BoxDecoration(
                color: AppTheme.accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.accent.withValues(alpha: 0.3)),
              ),
              child: const Text(
                'Kết nối thành công\nvới thiết bị !',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  setState(() => _syncState = 2);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.success,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('OK'),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: Row(
                  children: [
                    const Text('HealthTrack',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
                    const Spacer(),
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const HealthTrackLogo(size: 32),
                    ),
                  ],
                ),
              ),
            ),
            // Back button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Sync icon
            Container(
              width: 100, height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF1A2560),
                border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 2),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    _syncState == 2 ? Icons.directions_walk : Icons.directions_walk,
                    color: Colors.white.withValues(alpha: 0.8),
                    size: 50,
                  ),
                  if (_syncState == 2)
                    Positioned(
                      bottom: 8, right: 8,
                      child: Container(
                        width: 24, height: 24,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: AppTheme.success,
                        ),
                        child: const Icon(Icons.check, color: Colors.white, size: 16),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Sync buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  _syncButton(
                    'Đồng bộ với ứng dụng',
                    Icons.phone_android,
                    _syncWithApp,
                  ),
                  const SizedBox(height: 14),
                  _syncButton(
                    'Đồng bộ với thiết bị thông minh',
                    Icons.watch,
                    _syncWithDevice,
                  ),
                ],
              ),
            ),
            const Spacer(),
            // Weather info section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _infoCard(
                    Icons.cloud,
                    'Lần mưa hoặc tuyết tiếp theo:',
                    'không có sẵn',
                  ),
                  const SizedBox(height: 10),
                  _infoCard(
                    Icons.speed,
                    'Áp suất khí quyển hiện tại',
                    '1013 hPa',
                  ),
                  const SizedBox(height: 10),
                  // Three dots indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (i) => Container(
                      width: 8, height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i == 0 ? Colors.white : Colors.white.withValues(alpha: 0.3),
                      ),
                    )),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _syncButton(String text, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A2560),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white.withValues(alpha: 0.7), size: 20),
            const SizedBox(width: 10),
            Text(text, style: const TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500,
            )),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(IconData icon, String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2560),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white.withValues(alpha: 0.6), size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(
                  fontSize: 12, color: Colors.white.withValues(alpha: 0.6),
                )),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(
                  fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
