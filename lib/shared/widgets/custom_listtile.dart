import 'package:flutter/material.dart';

class CustomListtile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color iconColor;
  final Color iconBgColor;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showTrailing; // Added a flag to explicitly hide it if needed

  const CustomListtile({
    Key? key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.iconColor = Colors.black87,
    this.iconBgColor = const Color(0xFFF5F5F7),
    this.trailing,
    this.onTap,
    this.showTrailing = true, // Defaults to true
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
        child: Row(
          children: [
            // Icon Container
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 16),

            // Text Labels
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ]
                ],
              ),
            ),

            // Trailing Element Logic
            if (!showTrailing)
              const SizedBox.shrink() // Hides everything completely
            else if (trailing != null)
              trailing! // Shows your custom backend-driven widget
            else
              const Icon( // Default chevron
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.black26,
              ),
          ],
        ),
      ),
    );
  }
}