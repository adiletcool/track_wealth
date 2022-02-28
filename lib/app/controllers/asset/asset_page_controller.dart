import 'package:get/get.dart';

import '../../data/enums/market_types.dart';
import '../../data/enums/moex_enums.dart';
import '../../data/model/asset/asset_model.dart';
import '../../data/model/asset_history/ohlcv_model.dart';
import '../../data/repository/asset_repository.dart';

class AssetPageController extends GetxController {
  AssetModel asset = Get.arguments;
  final AssetRepository assetRepository;

  late final Future<void> initialLoad;
  late final List<OhlcvModel> assetHistory;
  late final MoexModelWithMarketData? mdAsset;

  AssetPageController(this.assetRepository);

  Future<List<OhlcvModel>> getMoexAssetHistory({
    required SearchMoexModel asset,
    MoexAssetHistoryInterval interval = MoexAssetHistoryInterval.d,
    int nCandles = 30,
  }) =>
      assetRepository.getMoexAssetHistory(asset: asset, interval: interval, nCandles: nCandles);

  Future<void> loadInitialAssetHistory() async {
    print('Loading initial asset history');

    switch (asset.assetType) {
      case AssetType.stocks:
        assetHistory = await getMoexAssetHistory(asset: asset as SearchMoexModel);
        print('Asset history loaded');
        break;
      case AssetType.bonds:
      case AssetType.currencies:
      case AssetType.crypto:
        throw UnimplementedError();
    }
  }

  Future<void> loadMdAsset() async {
    print('Loading initial asset market data');
    switch (asset.assetType) {
      case AssetType.stocks:
        mdAsset = await assetRepository.getMoexAssetWithMarketData(asset as SearchMoexModel);
        print('Asset market data loaded');
        break;
      case AssetType.bonds:
      case AssetType.currencies:
      case AssetType.crypto:
        throw UnimplementedError();
    }
  }

  @override
  void onInit() {
    initialLoad = Future.wait([
      loadInitialAssetHistory(),
      loadMdAsset(),
    ]);
    super.onInit();
  }
}
