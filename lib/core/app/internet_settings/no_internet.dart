import 'package:flutter/material.dart';

class NoInternetWidget extends StatefulWidget {
  const NoInternetWidget({super.key});

  @override
  State<NoInternetWidget> createState() => _NoInternetWidgetState();
}

class _NoInternetWidgetState extends State<NoInternetWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(
        milliseconds: 2000,
      ), // 2 seconds total cycle (faster)
      vsync: this,
    )..repeat();

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color.fromARGB(170, 74, 74, 74),
      child: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: CustomPaint(
                    size: const Size(200, 100),
                    painter: NoWiFiPainter(animationValue: _controller.value),
                  ),
                );
              },
            ),
            const Text(
              'No Internet Connection',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Please check your network',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NoWiFiPainter extends CustomPainter {
  final double animationValue;

  NoWiFiPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt;

    final center = Offset(size.width / 2, size.height / 2 + 20);

    // REVERSED ORDER: Innermost to Outermost
    // 0.0 - 0.2: Fourth (innermost) arc changes
    // 0.2 - 0.4: Third arc changes
    // 0.4 - 0.6: Second arc changes
    // 0.6 - 0.8: First (outermost) arc changes
    // 0.8 - 1.0: All reset to gray

    bool isFourthPurple = animationValue >= 0.0 && animationValue < 0.8;
    bool isThirdPurple = animationValue >= 0.2 && animationValue < 0.8;
    bool isSecondPurple = animationValue >= 0.4 && animationValue < 0.8;
    bool isFirstPurple = animationValue >= 0.6 && animationValue < 0.8;

    // Draw outer arc (largest) - Last to change
    paint.color = isFirstPurple ? Color(0xff1F4287) : Colors.grey.shade400;
    paint.strokeWidth = 20;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 85),
      -3.14 * 0.76,
      3.14 * 0.51,
      false,
      paint,
    );

    // Draw middle arc - Third to change
    paint.color = isSecondPurple ? Color(0xff1F4287) : Colors.grey.shade400;
    paint.strokeWidth = 18;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 58),
      -3.14 * 0.75,
      3.14 * 0.5,
      false,
      paint,
    );

    // Draw inner arc - Second to change
    paint.color = isThirdPurple ? Color(0xff1F4287) : Colors.grey.shade400;
    paint.strokeWidth = 16;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 32),
      -3.14 * 0.74,
      3.14 * 0.47,
      false,
      paint,
    );

    // Draw innermost arc - First to change
    paint.color = isFourthPurple ? Color(0xff1F4287) : Colors.grey.shade400;
    paint.strokeWidth = 14;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 12),
      -3.14 * 0.73,
      3.14 * 0.45,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(NoWiFiPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
