import 'dart:math' as math;

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:track_wealth/app/data/model/asset/coinmarketcap/coinmarketcap_model.dart';
import 'package:track_wealth/app/data/model/asset_chart/coinmarketcap_chart_interval.dart';

import '../../data/enums/market_types.dart';
import '../../data/model/asset/asset_model.dart';
import '../../data/model/asset/moex/moex_model.dart';
import '../../data/model/asset_chart/asset_chart_interval.dart';
import '../../data/model/asset_chart/moex_chart_interval.dart';
import '../../data/model/asset_chart/ohlcv_model.dart';
import '../../data/repository/asset_repository.dart';

enum ChartType { candlestick, line }

class AssetPageController extends GetxController {
  final AssetRepository assetRepository;

  AssetPageController(this.assetRepository);

  AssetModel asset = Get.arguments;

  RxBool isInitalLoaded = false.obs;

  late final AssetModelWithMarketData? mdAsset;
  late ChartController chart;

  Future<void> loadMdAsset() async {
    /// loads asset with market data: last price, day change, etc.
    switch (asset.assetType) {
      case AssetType.stocks:
        mdAsset = await assetRepository.getMoexAssetWithMarketData(asset as SearchMoexModel);
        break;
      case AssetType.bonds:
      case AssetType.currencies:
        throw UnimplementedError(); // TODO

      case AssetType.crypto:
        mdAsset = await assetRepository.getCoinmarketcapAssetWithMarketData(asset as SearchCoinmarketcapModel);
        break;
    }
  }

  @override
  Future<void> onInit() async {
    chart = ChartController(assetRepository, asset);
    chart.initInterval();

    await Future.wait([chart.loadData(), loadMdAsset()]);
    isInitalLoaded.value = true;
    super.onInit();
  }
}

class ChartController {
  final AssetRepository assetRepository;
  final AssetModel asset;

  ChartController(this.assetRepository, this.asset);

  Rx<DateFormat> xAxisDateFormat = DateFormat.MMMd(Get.deviceLocale?.languageCode).obs;

  late List<OhlcvModel> data;
  Rx<Future<void>> isLoading = Future<void>.value().obs;
  late Rx<AssetChartInterval> interval;
  Rx<ChartType> type = ChartType.candlestick.obs;

  double get maxVolume => data.map((i) => i.volume).reduce(math.max).toDouble();

  RxInt trackballIndex = 0.obs;
  RxBool trackballVisible = false.obs; // interaction with graph (long press)

  String get trackballDate {
    var ts = data[trackballIndex.value].timestamp;
    // TODO: fix 3 hours difference
    var dt = DateTime.fromMillisecondsSinceEpoch(ts, isUtc: true);
    return DateFormat.yMMMd(Get.deviceLocale?.languageCode).add_Hm().format(dt);
  }

  void setTrackballVisibility(bool isVisible) => trackballVisible.value = isVisible;
  void setTrackballIndex(int seriesIndex) => trackballIndex.value = seriesIndex;
  void changeType() => type.value = type.value == ChartType.line ? ChartType.candlestick : ChartType.line;

  void setInterval(AssetChartInterval newInterval) {
    if (interval.value == newInterval) return;

    interval.value = newInterval;
    isLoading.value = loadData();

    // change xAxisDateFormat if period is large

    switch (newInterval.title) {
      case '24h':
        xAxisDateFormat.value = DateFormat.MMMd(Get.deviceLocale?.languageCode).add_Hm();
        break;
      case '5Y':
        xAxisDateFormat.value = DateFormat.yMMMd(Get.deviceLocale?.languageCode);
        break;
      default:
        xAxisDateFormat.value = DateFormat.MMMd(Get.deviceLocale?.languageCode);
        break;
    }
  }

  Future<void> loadData() async {
    /// Loads ohlcv series for chart

    switch (asset.assetType) {
      case AssetType.stocks:
        data = await assetRepository.getMoexAssetChart(
          asset: asset as SearchMoexModel,
          interval: interval.value as MoexChartInterval,
        );
        break;

      case AssetType.crypto:
        data = await assetRepository.getCoinmarketcapAssetChart(
          asset: asset as SearchCoinmarketcapModel,
          interval: interval.value as CoinmarketcapChartInterval,
        );
        break;

      case AssetType.bonds:
      case AssetType.currencies:
        throw UnimplementedError();
    }
  }

  void initInterval() {
    switch (asset.assetType) {
      case AssetType.stocks:
      case AssetType.bonds:
      case AssetType.currencies:
        interval = MoexChartInterval.month().obs;
        break;

      case AssetType.crypto:
        interval = CoinmarketcapChartInterval.month().obs;
        break;
    }
  }
}
