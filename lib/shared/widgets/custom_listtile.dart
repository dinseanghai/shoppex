import 'package:flutter/material.dart';

class CustomListtile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle; // Handles: Text, Dynamic string from backend, or null
  final Color iconColor;
  final Color iconBgColor;
  final Widget? trailing; // Handles: Badges (like "Verified"), Toggles, or Custom Widgets
  final VoidCallback? onTap;
  final bool showTrailing;

  const CustomListtile({
    Key? key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.iconColor = Colors.black87,
    this.iconBgColor = const Color(0xFFF5F5F7),
    this.trailing,
    this.onTap,
    this.showTrailing = true,
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

            // Text Labels (Title & Subtitle)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  if (subtitle != null && subtitle!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black45, // Matches your muted image text
                      ),
                    ),
                  ]
                ],
              ),
            ),

            // Trailing Element Logic (Can be dynamic badge, toggle, chevron, or blank)
            if (!showTrailing)
              const SizedBox.shrink()
            else if (trailing != null)
              trailing!
            else
              const Icon(
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