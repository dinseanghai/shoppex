import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final double size;
  final Color? color;
  final bool isButtonMode;

  const LoadingWidget({
    super.key,
    this.size = 40.0,
    this.color,
    this.isButtonMode = false,
  });

  @override
  Widget build(BuildContext context) {
    // Fallback to theme colors depending on the context
    final themeColor = color ??
        (isButtonMode
            ? Theme.of(context).colorScheme.onPrimary
            : Theme.of(context).colorScheme.primary);

    // If used in a button, we scale down the loader automatically
    final finalSize = isButtonMode ? 20.0 : size;

    return Center(
      child: SizedBox(
        width: finalSize,
        height: finalSize,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer subtle glowing ring (Modern design touch)
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: themeColor.withOpacity(0.15),
                    blurRadius: finalSize * 0.4,
                    spreadRadius: finalSize * 0.1,
                  ),
                ],
              ),
            ),
            // The actual animated progress indicator
            CircularProgressIndicator(
              strokeWidth: isButtonMode ? 2.5 : 3.5,
              valueColor: AlwaysStoppedAnimation<Color>(themeColor),
              // Gives it that smooth, modern variable-speed spin
              strokeCap: StrokeCap.round,
            ),
          ],
        ),
      ),
    );
  }
}