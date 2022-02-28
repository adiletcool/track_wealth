import 'package:get/get.dart';

import '../../data/provider/coinmarketcap_api.dart';
import '../../data/provider/moex_api.dart';
import '../../data/repository/asset_repository.dart';
import 'asset_page_controller.dart';

class AssetPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AssetPageController>(
      () => AssetPageController(
        AssetRepository(
          moexApiClient: MoexApiClient(),
          cmcApiClient: CoinmarketcapApiClient(),
        ),
      ),
    );
  }
}
