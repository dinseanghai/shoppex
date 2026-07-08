import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> makePhoneCall(String phoneNumber) async {

  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber.replaceAll(' ', ''),
  );

  if (await canLaunchUrl(launchUri)) {
    await launchUrl(launchUri);
  } else {
    // Handle the error gracefully if the device cannot make calls (like an iPad/Tablet)
    debugPrint('Could not launch phone dialer for $phoneNumber');
  }
}