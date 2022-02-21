import 'package:get/get.dart';
import 'package:track_wealth/app/controllers/operations/operations_controller.dart';
import 'package:track_wealth/app/controllers/profile/profile_controller.dart';

import '../controllers/dashboard/dashboard_controller.dart';
import '../controllers/home/asset_search_controller.dart';
import '../controllers/home/home_controller.dart';
import '../data/provider/coinmarketcap_api.dart';
import '../data/provider/moex_api.dart';
import '../data/repository/moex_repository.dart';

class DashboardBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());

    Get.lazyPut<HomeController>(() => HomeController());

    Get.lazyPut<AssetSearchController>(() {
      return AssetSearchController(
        AssetRepository(
          moexApiClient: MoexApiClient(),
          cmcApiClient: CoinmarketcapApiClient(),
        ),
      );
    });

    Get.lazyPut<OperationsController>(() => OperationsController());

    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
