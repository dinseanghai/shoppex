import 'package:flutter/material.dart';
import 'package:shoppex/core/constants/app_assets.dart';
import 'package:shoppex/core/constants/app_size.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onTap;

  const GoogleSignInButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0), // Makes the button capsule-shaped
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3), // Soft, subtle shadow
              blurRadius: 6.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max, // Shrinks the button to fit the content
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            SizedBox(
                height: 20,
                child: Image.asset(AppAssets.google)),
            AppSizes.gapW8,
            const Text(
              'Google',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F1F1F), // Off-black color for a modern look
                fontFamily: 'Roboto', // Use your app's preferred font
              ),
            ),
          ],
        ),
      ),
    );
  }
}