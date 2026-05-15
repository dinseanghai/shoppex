import '../../flavors.dart';

class AppConfig {
  static String get baseUrl {
    switch (F.appFlavor) {
      case Flavor.prod:
        return "https://portal-shoppex-dev.hushstackcambodia.site";
      case Flavor.dev:
      default:
        return "http://localhost:8000";
    }
  }
}