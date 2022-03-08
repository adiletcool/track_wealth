import 'package:get/get.dart';

import '../../data/provider/coinmarketcap_api.dart';
import '../../data/provider/moex_api.dart';
import '../../data/repository/asset_repository.dart';
import '../history/history_controller.dart';
import '../home/asset_search_controller.dart';
import '../home/home_controller.dart';
import '../profile/profile_controller.dart';
import 'dashboard_controller.dart';

class DashboardPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardPageController>(() => DashboardPageController());

    // Load cmc crypto map
    Get.put<AssetSearchController>(AssetSearchController(
      AssetRepository(
        moexApiClient: MoexApiClient(),
        cmcApiClient: CoinmarketcapApiClient(),
      ),
    ));

    Get.lazyPut<HomePageController>(() => HomePageController());

    Get.lazyPut<HistoryPageController>(() => HistoryPageController());

    Get.lazyPut<ProfilePageController>(() => ProfilePageController());
  }
}
