// password_strength_indicator.dart
import 'package:flutter/material.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  final int strength;

  const PasswordStrengthIndicator({
    super.key,
    required this.strength,
  });

  /// Logic to determine segment colors
  Color _getBarColor(int barIndex) {
    if (strength < barIndex) return Colors.grey.shade300;

    switch (strength) {
      case 1: return Colors.red;
      case 2: return Colors.orange;
      case 3: return Colors.blue;
      case 4: return Colors.green;
      default: return Colors.grey.shade300;
    }
  }

  /// Logic to determine text label
  String get _strengthText {
    switch (strength) {
      case 1: return 'Weak';
      case 2: return 'Fair';
      case 3: return 'Good';
      case 4: return 'Strong';
      default: return '';
    }
  }

  /// Logic to determine text color
  Color get _strengthTextColor {
    switch (strength) {
      case 1: return Colors.red;
      case 2: return Colors.orange;
      case 3: return Colors.blue;
      case 4: return Colors.green;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. The 4-segment colored bar rows
          Row(
            children: List.generate(4, (index) {
              int barIndex = index + 1;
              return Expanded(
                child: Container(
                  height: 4,
                  margin: EdgeInsets.symmetric(horizontal: barIndex == 1 ? 0 : 4),
                  decoration: BoxDecoration(
                    color: _getBarColor(barIndex),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 6),

          // 2. The text label row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Password strength',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              Text(
                _strengthText,
                style: TextStyle(
                  color: _strengthTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}