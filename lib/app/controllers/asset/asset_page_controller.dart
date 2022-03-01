import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../data/enums/market_types.dart';
import '../../data/model/asset/asset_model.dart';
import '../../data/model/asset_chart/asset_chart_interval.dart';
import '../../data/model/asset_chart/ohlcv_model.dart';
import '../../data/repository/asset_repository.dart';

class AssetPageController extends GetxController {
  final AssetRepository assetRepository;

  AssetPageController(this.assetRepository);

  AssetModel asset = Get.arguments;

  RxBool isInitalLoaded = false.obs;
  Rx<Future<void>> isChartLoading = Future<void>.value().obs;

  late List<OhlcvModel> assetChart;
  late final MoexModelWithMarketData? mdAsset;

  Rx<AssetChartInterval> chartInterval = MoexAssetChartInterval.M().obs;
  RxBool trackballVisible = false.obs; // interaction with graph (long press)

  RxInt trackballIndex = 0.obs;

  String get trackballDate {
    var ts = assetChart[trackballIndex.value].timestamp;
    var dt = DateTime.fromMillisecondsSinceEpoch(ts);
    return DateFormat.yMMMd(Get.deviceLocale?.languageCode).add_Hm().format(dt);
  }

  void setChartInterval(AssetChartInterval interval) {
    chartInterval.value = interval;
    isChartLoading.value = loadAssetChart();
  }

  void setTrackballVisibility(bool isVisible) => trackballVisible.value = isVisible;
  void setTrackballIndex(int seriesIndex) => trackballIndex.value = seriesIndex;

  Future<void> loadAssetChart() async {
    /// Loads ohlcv series for chart
    print('Loading initial asset history');

    switch (asset.assetType) {
      case AssetType.stocks:
        assetChart = await assetRepository.getMoexAssetHistory(asset: asset as SearchMoexModel, interval: chartInterval.value);
        print('Asset history loaded');
        break;
      case AssetType.bonds:
      case AssetType.currencies:
      case AssetType.crypto:
        throw UnimplementedError();
    }
  }

  Future<void> loadMdAsset() async {
    /// loads asset with market data: last price, day change, etc.
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
    isChartLoading.value = Future.wait([loadAssetChart(), loadMdAsset()]);
    isChartLoading.value.then((_) => isInitalLoaded.value = true);

    super.onInit();
  }
}
