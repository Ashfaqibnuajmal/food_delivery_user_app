import 'package:flutter/material.dart';

class PaymentSuccessController {
  late AnimationController circleCtrl;
  late AnimationController checkCtrl;
  late AnimationController textCtrl;
  late AnimationController rippleCtrl;

  late Animation<double> circleScale;
  late Animation<double> checkProgress;
  late Animation<double> textOpacity;
  late Animation<double> textSlide;
  late Animation<double> rippleScale;
  late Animation<double> rippleOpacity;

  // ── Initialize all controllers ─────────────────────────────────────────────
  void init(TickerProvider vsync) {
    circleCtrl = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 550),
    );
    checkCtrl = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 700),
    );
    textCtrl = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 450),
    );
    rippleCtrl = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 900),
    );

    circleScale = CurvedAnimation(parent: circleCtrl, curve: Curves.elasticOut);
    checkProgress = CurvedAnimation(parent: checkCtrl, curve: Curves.easeInOut);
    textOpacity = CurvedAnimation(parent: textCtrl, curve: Curves.easeIn);
    textSlide = Tween<double>(
      begin: 25.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: textCtrl, curve: Curves.easeOut));
    rippleScale = Tween<double>(
      begin: 1.0,
      end: 2.2,
    ).animate(CurvedAnimation(parent: rippleCtrl, curve: Curves.easeOut));
    rippleOpacity = Tween<double>(
      begin: 0.4,
      end: 0.0,
    ).animate(CurvedAnimation(parent: rippleCtrl, curve: Curves.easeOut));
  }

  // ── Run animation sequence ─────────────────────────────────────────────────
  Future<void> runSequence() async {
    await circleCtrl.forward();
    rippleCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 100));
    await checkCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 150));
    await textCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 1800));
  }

  // ── Dispose all controllers ────────────────────────────────────────────────
  void dispose() {
    circleCtrl.dispose();
    checkCtrl.dispose();
    textCtrl.dispose();
    rippleCtrl.dispose();
  }
}

// ── Checkmark painter ──────────────────────────────────────────────────────────
class CheckmarkPainter extends CustomPainter {
  final double progress;

  const CheckmarkPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0) return;

    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final p1 = Offset(size.width * 0.26, size.height * 0.50);
    final p2 = Offset(size.width * 0.44, size.height * 0.67);
    final p3 = Offset(size.width * 0.74, size.height * 0.36);

    final seg1Len = (p2 - p1).distance;
    final seg2Len = (p3 - p2).distance;
    final total = seg1Len + seg2Len;
    final seg1Progress = seg1Len / total;

    final path = Path()..moveTo(p1.dx, p1.dy);

    if (progress <= seg1Progress) {
      final t = progress / seg1Progress;
      path.lineTo(p1.dx + (p2.dx - p1.dx) * t, p1.dy + (p2.dy - p1.dy) * t);
    } else {
      final t = (progress - seg1Progress) / (1 - seg1Progress);
      path
        ..lineTo(p2.dx, p2.dy)
        ..lineTo(p2.dx + (p3.dx - p2.dx) * t, p2.dy + (p3.dy - p2.dy) * t);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CheckmarkPainter old) => old.progress != progress;
}
