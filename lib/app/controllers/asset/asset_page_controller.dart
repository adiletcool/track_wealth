import 'package:get/get.dart';

import '../../data/enums/market_types.dart';
import '../../data/model/asset/asset_model.dart';
import '../../data/model/asset_history/asset_history_interval.dart';
import '../../data/model/asset_history/ohlcv_model.dart';
import '../../data/repository/asset_repository.dart';

class AssetPageController extends GetxController {
  final AssetRepository assetRepository;

  AssetPageController(this.assetRepository);

  AssetModel asset = Get.arguments;

  late final Future<void> initialLoad;
  late final List<OhlcvModel> assetHistory;
  late final MoexModelWithMarketData? mdAsset;

  Rx<AssetHistoryInterval> chartInterval = MoexAssetHistoryInterval.M().obs;

  void setChartInterval(AssetHistoryInterval interval) {
    // TODO: load series with new interval
    chartInterval.value = interval;
  }

  Future<List<OhlcvModel>> getMoexAssetHistory({
    required SearchMoexModel asset,
    required AssetHistoryInterval interval,
  }) =>
      assetRepository.getMoexAssetHistory(asset: asset, interval: interval);

  Future<void> loadInitialAssetHistory() async {
    print('Loading initial asset history');

    switch (asset.assetType) {
      case AssetType.stocks:
        assetHistory = await getMoexAssetHistory(asset: asset as SearchMoexModel, interval: chartInterval.value);
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
