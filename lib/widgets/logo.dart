import 'package:flutter/material.dart';

class HealthTrackLogo extends StatelessWidget {
  final double size;
  const HealthTrackLogo({super.key, this.size = 100});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _LogoPainter()),
    );
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Heart shape
    final heartPath = Path();
    heartPath.moveTo(w * 0.5, h * 0.85);
    heartPath.cubicTo(w * 0.15, h * 0.65, -w * 0.05, h * 0.3, w * 0.25, h * 0.15);
    heartPath.cubicTo(w * 0.35, h * 0.08, w * 0.45, h * 0.12, w * 0.5, h * 0.25);
    heartPath.cubicTo(w * 0.55, h * 0.12, w * 0.65, h * 0.08, w * 0.75, h * 0.15);
    heartPath.cubicTo(w * 1.05, h * 0.3, w * 0.85, h * 0.65, w * 0.5, h * 0.85);
    heartPath.close();

    // Heart gradient (red-orange top to deep blue bottom)
    final heartPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFFFF6B35),
          const Color(0xFFE63946),
          const Color(0xFFE63946),
          const Color(0xFF2541B2),
          const Color(0xFF0C4A6E),
        ],
        stops: const [0.0, 0.25, 0.4, 0.7, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawPath(heartPath, heartPaint);

    // Heartbeat ECG line
    final ecgPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = w * 0.035
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final ecgPath = Path();
    ecgPath.moveTo(w * 0.12, h * 0.46);
    ecgPath.lineTo(w * 0.28, h * 0.46);
    ecgPath.lineTo(w * 0.35, h * 0.32);
    ecgPath.lineTo(w * 0.42, h * 0.56);
    ecgPath.lineTo(w * 0.50, h * 0.30);
    ecgPath.lineTo(w * 0.58, h * 0.58);
    ecgPath.lineTo(w * 0.63, h * 0.42);
    ecgPath.lineTo(w * 0.72, h * 0.46);
    ecgPath.lineTo(w * 0.88, h * 0.46);
    canvas.drawPath(ecgPath, ecgPaint);

    // Small stethoscope circle on upper right
    final circlePaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFF60A5FA), Color(0xFF3B82F6)],
      ).createShader(Rect.fromCircle(center: Offset(w * 0.72, h * 0.18), radius: w * 0.06));
    canvas.drawCircle(Offset(w * 0.72, h * 0.18), w * 0.06, circlePaint);

    // Highlight/gloss on heart
    final glossPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.5, -0.6),
        radius: 0.6,
        colors: [Colors.white.withValues(alpha: 0.25), Colors.transparent],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawPath(heartPath, glossPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// AI Bot Avatar matching the reference
class AiBotAvatar extends StatelessWidget {
  final double size;
  const AiBotAvatar({super.key, this.size = 80});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFF4361EE), Color(0xFF3A86FF), Color(0xFF6366F1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 2),
        boxShadow: [
          BoxShadow(color: const Color(0xFF4361EE).withValues(alpha: 0.4), blurRadius: 20, spreadRadius: 2),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.psychology, color: Colors.white, size: size * 0.35),
            Text('AI', style: TextStyle(
              color: Colors.white, fontSize: size * 0.18,
              fontWeight: FontWeight.w800, letterSpacing: 2,
            )),
          ],
        ),
      ),
    );
  }
}
