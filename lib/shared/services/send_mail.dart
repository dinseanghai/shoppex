import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> sendEmail(String emailAddress) async {
  final Uri launchUri = Uri(
    scheme: 'mailto',
    path: emailAddress,
  );

  try {
    // Attempt directly without checking visibility restrictions
    await launchUrl(launchUri);
  } catch (e) {
    debugPrint('Could not launch email client: $e');
  }
}