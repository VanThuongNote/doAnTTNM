
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/logo.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _logoController;
  late Animation<double> _logoAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _logoController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _logoAnimation = CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack);
    _logoController.forward();

    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const LoginScreen(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Color(0xFF0A0A2E)),
        child: Stack(
          children: [
            // Animated circles
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                final value = _pulseController.value;
                return Stack(
                  children: [
                    Positioned(
                      top: -100,
                      left: -100,
                      child: _buildCircle(500, value, AppTheme.primaryLight.withValues(alpha: 0.3),
                          AppTheme.primary.withValues(alpha: 0.15)),
                    ),
                    Positioned(
                      bottom: -50,
                      right: -80,
                      child: _buildCircle(350, 1 - value, AppTheme.pink.withValues(alpha: 0.3),
                          AppTheme.pink.withValues(alpha: 0.1)),
                    ),
                    Center(
                      child: _buildCircle(200, (value + 0.5) % 1.0,
                          AppTheme.accent.withValues(alpha: 0.2), Colors.transparent),
                    ),
                  ],
                );
              },
            ),
            // Logo
            Center(
              child: ScaleTransition(
                scale: _logoAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primary.withValues(alpha: 0.4),
                            blurRadius: 32,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.monitor_heart, color: Colors.white, size: 44),
                    ),
                    const SizedBox(height: 16),
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('HEALTH', style: TextStyle(color: Color(0xFF1A3A7A), fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: 1)),
                        Text('TRACK', style: TextStyle(color: Color(0xFF10B981), fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: 1)),
                      ],
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

  Widget _buildCircle(double size, double animValue, Color borderColor, Color fillColor) {
    return Transform.scale(
      scale: 1.0 + animValue * 0.08,
      child: Opacity(
        opacity: 0.7 + animValue * 0.3,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: borderColor, width: 2),
            gradient: RadialGradient(
              colors: [fillColor, Colors.transparent],
              stops: const [0.0, 0.7],
            ),
          ),
        ),
      ),
    );
  }
}
