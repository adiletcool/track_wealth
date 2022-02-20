import 'package:get/get.dart';

import '../controllers/home/market_search_controller.dart';
import '../data/provider/moex_api.dart';
import '../data/repository/moex_repository.dart';

class AssetSearchBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AssetSearchController>(() {
      return AssetSearchController(
        MoexRepository(
          moexApiClient: MoexApiClient(),
        ),
      );
    });
  }
}
