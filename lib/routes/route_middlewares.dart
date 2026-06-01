import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoppex/routes/app_pages.dart';
import '../shared/services/auth_service.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {

    // 1. If the user HAS a valid authenticated token...
    if (AuthService.to.hasToken) {
      // Skip onboarding and login, send them straight to the main layout
      if (route == Routes.ONBOARDING || route == Routes.SIGNIN) {
        return const RouteSettings(name: Routes.MAIN_LAYOUT);
      }
      return null;
    }

    // 2. If the user DOES NOT have a token (Guest Mode)...

    // Allow them to see Onboarding or Sign-In if they explicitly navigate there
    if (route == Routes.ONBOARDING || route == Routes.SIGNIN) {
      return null;
    }

    // ⭐ CRITICAL CHANGE FOR GUEST MODE:
    // If they don't have a token, but they are trying to access the MAIN_LAYOUT,
    // ALLOW them to pass through cleanly so they can browse the app as a guest!
    if (route == Routes.MAIN_LAYOUT) {
      return null;
    }

    // Bounce unauthenticated traffic attempting to access deep secure pages back to Sign-In
    return const RouteSettings(name: Routes.SIGNIN);
  }
}