import '../model/asset/coinmarketcap/coinmarketcap_model.dart';
import '../model/asset/moex/moex_model.dart';
import '../model/asset_chart/coinmarketcap_chart_interval.dart';
import '../model/asset_chart/moex_chart_interval.dart';
import '../model/asset_chart/ohlcv_model.dart';
import '../provider/coinmarketcap_api.dart';
import '../provider/moex_api.dart';

class AssetRepository {
  final MoexApiClient moexApiClient;
  final CoinmarketcapApiClient cmcApiClient;

  AssetRepository({required this.moexApiClient, required this.cmcApiClient});

  Future<List<SearchMoexModel>> searchMoexAssets(String query) => moexApiClient.searchMoexAssets(query);

  Future<List<SearchCoinmarketcapModel>> getCoinmarketcapAssets() => cmcApiClient.getCoinmarketcapAssets();

  Future<MoexModelWithMarketData?> getMoexAssetWithMarketData(SearchMoexModel asset) => moexApiClient.getMoexAssetWithMarketData(asset);

  Future<CoinmarketcapModelWithMarketData?> getCoinmarketcapAssetWithMarketData(SearchCoinmarketcapModel asset) =>
      cmcApiClient.getCoinmarketcapAssetWithMarketData(asset);

  Future<List<OhlcvModel>> getMoexAssetChart({
    required SearchMoexModel asset,
    required MoexChartInterval interval,
  }) =>
      moexApiClient.getMoexAssetChart(asset: asset, interval: interval);

  Future<List<OhlcvModel>> getCoinmarketcapAssetChart({
    required SearchCoinmarketcapModel asset,
    required CoinmarketcapChartInterval interval,
  }) =>
      cmcApiClient.getCoinmarketcapAssetChart(asset: asset, interval: interval);
}
