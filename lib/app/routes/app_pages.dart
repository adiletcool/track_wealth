import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:track_wealth/app/binding/home_bindings.dart';
import 'package:track_wealth/app/ui/android/auth/auth_page.dart';
import 'package:track_wealth/app/ui/android/home/home_page.dart';
import 'package:track_wealth/app/ui/android/market/market_page.dart';

part './app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.initial,
      page: () => const HomePage(),
      binding: HomeBinding(),
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
    GetPage(
      name: Routes.market,
      page: () => MarketPage(),
      transition: Transition.downToUp,
      transitionDuration: 250.milliseconds,
    ),
  ];
}
