import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:track_wealth/app/binding/market_bindings.dart';
import 'package:track_wealth/app/ui/android/auth/auth_page.dart';
import 'package:track_wealth/app/ui/android/home/home_page.dart';

part './app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.initial,
      page: () => HomePage(),
      bindings: [
        AssetSearchBinding(),
      ],
    ),
    GetPage(
      name: Routes.auth,
      page: () {
        SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp],
        );
        return AuthPage();
      },
    ),
  ];
}
