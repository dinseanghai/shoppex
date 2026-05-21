import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoppex/routes/app_pages.dart';
import '../shared/services/auth_service.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {

    // 1. If the user HAS a valid authenticated token...
    if (AuthService.to.hasToken) {
      // ...and they are hitting the root entry points, skip directly to Home!
      if (route == Routes.ONBOARDING || route == Routes.SIGNIN) {
        return const RouteSettings(name: Routes.HOME);
      }
      // For any other internal secured routes, let them pass through cleanly
      return null;
    }

    // 2. If the user DOES NOT have a token...
    // Allow them to navigate freely through onboarding or login setups
    if (route == Routes.ONBOARDING || route == Routes.SIGNIN) {
      return null;
    }

    // Bounce unauthenticated traffic on inner protected routes back to login
    return const RouteSettings(name: Routes.SIGNIN);
  }
}