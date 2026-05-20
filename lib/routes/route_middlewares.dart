import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/local/secure_storage.dart';
import '../dependency_injection.dart';
import 'app_pages.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // Reads a plain boolean instantly without needing 'await'
    final bool isLoggedIn = DependencyInjection.isAuthenticated.value;

    if (isLoggedIn) {
      if (route == Routes.SIGNIN || route == Routes.SIGN_UP) {
        return const RouteSettings(name: Routes.HOME);
      }
    } else {
      if (route != Routes.SIGNIN && route != Routes.SIGN_UP) {
        return const RouteSettings(name: Routes.SIGNIN);
      }
    }
    return null;
  }
}