import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../bindings/dashboard_binding.dart';
import '../ui/android/auth/auth_page.dart';
import '../ui/android/dashboard_page.dart';

part './app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.auth,
      page: () {
        SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp],
        );
        return AuthPage();
      },
    ),
    GetPage(
      name: Routes.initial,
      page: () => DashboardPage(),
      binding: DashboardBinding(),
    ),
  ];
}
