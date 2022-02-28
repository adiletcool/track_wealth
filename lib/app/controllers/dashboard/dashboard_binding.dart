import 'package:get/get.dart';

import '../../data/provider/coinmarketcap_api.dart';
import '../../data/provider/moex_api.dart';
import '../../data/repository/asset_repository.dart';
import '../home/asset_search_controller.dart';
import '../home/home_controller.dart';
import '../operations/operations_controller.dart';
import '../profile/profile_controller.dart';
import 'dashboard_controller.dart';

class DashboardBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());

    // Load cmc crypto map
    Get.put<AssetSearchController>(AssetSearchController(
      AssetRepository(
        moexApiClient: MoexApiClient(),
        cmcApiClient: CoinmarketcapApiClient(),
      ),
    ));

    Get.lazyPut<HomeController>(() => HomeController());

    Get.lazyPut<OperationsController>(() => OperationsController());

    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
