import 'package:flutter/material.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/core/theme/text_style.dart';
import 'package:food_user_app/features/payment/payment_success_controller.dart';

class PaymentSuccessOverlay extends StatelessWidget {
  const PaymentSuccessOverlay({super.key});

  // ── Called from CheckoutController ─────────────────────────────────────────
  static Future<void> show(BuildContext context, {VoidCallback? onComplete}) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: Duration.zero,
      pageBuilder: (_, __, ___) =>
          _PaymentSuccessAnimator(onComplete: onComplete),
    );
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

// ── Private StatefulWidget — only handles vsync wiring ─────────────────────────
class _PaymentSuccessAnimator extends StatefulWidget {
  final VoidCallback? onComplete;

  const _PaymentSuccessAnimator({this.onComplete});

  @override
  State<_PaymentSuccessAnimator> createState() =>
      _PaymentSuccessAnimatorState();
}

class _PaymentSuccessAnimatorState extends State<_PaymentSuccessAnimator>
    with TickerProviderStateMixin {
  final PaymentSuccessController _ctrl = PaymentSuccessController();

  @override
  void initState() {
    super.initState();
    _ctrl.init(this);
    _startAnimation();
  }

  Future<void> _startAnimation() async {
    await _ctrl.runSequence();
    if (mounted) {
      Navigator.of(context).pop();
      widget.onComplete?.call();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Circle + Ripple + Checkmark ────────────────────────────────
            SizedBox(
              width: 160,
              height: 160,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Ripple ring
                  AnimatedBuilder(
                    animation: _ctrl.rippleCtrl,
                    builder: (_, __) => Transform.scale(
                      scale: _ctrl.rippleScale.value,
                      child: Opacity(
                        opacity: _ctrl.rippleOpacity.value,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primaryOrange,
                              width: 3,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Orange circle with glow
                  ScaleTransition(
                    scale: _ctrl.circleScale,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryOrange,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryOrange.withOpacity(0.5),
                            blurRadius: 28,
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Checkmark draws on
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: AnimatedBuilder(
                      animation: _ctrl.checkProgress,
                      builder: (_, __) => CustomPaint(
                        painter: CheckmarkPainter(
                          progress: _ctrl.checkProgress.value,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ── Text slides up + fades in ──────────────────────────────────
            AnimatedBuilder(
              animation: _ctrl.textCtrl,
              builder: (_, child) => Transform.translate(
                offset: Offset(0, _ctrl.textSlide.value),
                child: Opacity(opacity: _ctrl.textOpacity.value, child: child),
              ),
              child: const Text(
                'Payment Successful!',
                style: whiteBoldTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
