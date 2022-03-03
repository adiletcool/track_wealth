import 'package:get/get.dart';
import 'package:track_wealth/app/controllers/asset/asset_page_binding.dart';

import '../controllers/dashboard/dashboard_binding.dart';
import '../ui/mobile/asset/asset_page.dart';
import '../ui/mobile/auth/auth_page.dart';
import '../ui/mobile/dashboard_page.dart';

part './app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.auth,
      page: () => AuthPage(),
    ),
    GetPage(
      name: Routes.initial,
      page: () => DashboardPage(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: Routes.asset,
      page: () => const AssetPage(),
      binding: AssetPageBinding(),
    )
  ];
}
