import 'package:flutter/material.dart';

class FestPassLogo extends StatelessWidget {
  final double size;
  const FestPassLogo({super.key, this.size = 1.0});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Ticket icon with gradient feel
        Icon(
          Icons.local_activity,
          color: const Color(0xFF9C27B0),
          size: 28 * size,
        ),
        SizedBox(width: 6 * size),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Fest',
                style: TextStyle(
                  fontSize: 24 * size,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF9C27B0),
                  letterSpacing: -0.5,
                ),
              ),
              TextSpan(
                text: ' Pass',
                style: TextStyle(
                  fontSize: 24 * size,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFE91E63),
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class FestPassLogoWithSubtitle extends StatelessWidget {
  final double size;
  const FestPassLogoWithSubtitle({super.key, this.size = 1.0});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FestPassLogo(size: size),
        SizedBox(height: 2 * size),
        Text(
          'SEU PASSAPORTE PARA A DIVERSÃO',
          style: TextStyle(
            fontSize: 8 * size,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}
