import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Builds the colorful TTT-style event banner matching the mockup design
class EventBanner extends StatelessWidget {
  final int colorIndex;
  final double height;
  final BorderRadius? borderRadius;

  const EventBanner({
    super.key,
    required this.colorIndex,
    this.height = 220,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _getColors(colorIndex);

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colors[0], colors[1]],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: CustomPaint(
          painter: _ZigZagPainter(baseColor: colors[2]),
          child: Center(
            child: _buildLetters(colorIndex, colors),
          ),
        ),
      ),
    );
  }

  Widget _buildLetters(int index, List<Color> colors) {
    final letters = _getLetters(index);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: letters.map((letter) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            letter,
            style: TextStyle(
              fontSize: height * 0.35,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: colors[2].withOpacity(0.5),
                  offset: const Offset(3, 3),
                  blurRadius: 6,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  List<String> _getLetters(int index) {
    switch (index % 6) {
      case 0:
        return ['T', 'T', 'T'];
      case 1:
        return ['B', 'D', 'H'];
      case 2:
        return ['S', 'V', 'F'];
      case 3:
        return ['F', 'N'];
      case 4:
        return ['C', 'U', 'P'];
      case 5:
        return ['R', 'S'];
      default:
        return ['F', 'P'];
    }
  }

  List<Color> _getColors(int index) {
    switch (index % 6) {
      case 0: // Pink/Magenta - TTT
        return [
          const Color(0xFFE91E63),
          const Color(0xFFC2185B),
          const Color(0xFF880E4F),
        ];
      case 1: // Orange/Red - Baile
        return [
          const Color(0xFFFF5722),
          const Color(0xFFE64A19),
          const Color(0xFFBF360C),
        ];
      case 2: // Teal/Cyan - Sunset
        return [
          const Color(0xFFFF6F00),
          const Color(0xFFFF8F00),
          const Color(0xFFE65100),
        ];
      case 3: // Green/Lime - Neon
        return [
          const Color(0xFF00E676),
          const Color(0xFF69F0AE),
          const Color(0xFF1B5E20),
        ];
      case 4: // Blue/Purple - Calourada
        return [
          const Color(0xFF7C4DFF),
          const Color(0xFF651FFF),
          const Color(0xFF311B92),
        ];
      case 5: // Dark/Red - Rave
        return [
          const Color(0xFF212121),
          const Color(0xFF424242),
          const Color(0xFF000000),
        ];
      default:
        return [
          const Color(0xFFE91E63),
          const Color(0xFFC2185B),
          const Color(0xFF880E4F),
        ];
    }
  }
}

class _ZigZagPainter extends CustomPainter {
  final Color baseColor;
  _ZigZagPainter({required this.baseColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = baseColor.withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 30;

    // Draw zigzag lines across the banner
    for (int i = 0; i < 6; i++) {
      final path = Path();
      double startY = size.height * 0.1 + (i * size.height * 0.18);
      path.moveTo(-20, startY);

      for (double x = 0; x < size.width + 40; x += 40) {
        double yOffset = (x ~/ 40) % 2 == 0 ? -20 : 20;
        path.lineTo(x, startY + yOffset);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
