import 'package:get/get.dart';
import 'package:track_wealth/app/ui/mobile/operation/money_operation_page.dart';

import '../controllers/asset/asset_page_binding.dart';
import '../controllers/dashboard/dashboard_binding.dart';
import '../controllers/operation/operation_binding.dart';
import '../ui/mobile/asset/asset_page.dart';
import '../ui/mobile/auth/auth_page.dart';
import '../ui/mobile/dashboard_page.dart';
import '../ui/mobile/operation/trade_operation_page.dart';

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
      binding: DashboardPageBinding(),
    ),
    GetPage(
      name: Routes.asset,
      page: () => const AssetPage(),
      binding: AssetPageBinding(),
    ),
    GetPage(
      name: Routes.tradeOperation,
      page: () => const TradeOperationPage(),
      binding: TradeOperationPageBinding(),
    ),
    GetPage(
      name: Routes.moneyOperation,
      page: () => const MoneyOperationPage(),
      binding: MoneyOperationBinding(),
    ),
  ];
}
