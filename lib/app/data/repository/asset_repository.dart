import '../enums/moex_enums.dart';
import '../model/asset/asset_model.dart';
import '../model/asset/crypto_model.dart';
import '../model/asset_history/ohlcv_model.dart';
import '../provider/coinmarketcap_api.dart';
import '../provider/moex_api.dart';

class AssetRepository {
  final MoexApiClient moexApiClient;
  final CoinmarketcapApiClient cmcApiClient;

  AssetRepository({required this.moexApiClient, required this.cmcApiClient});

  Future<List<SearchMoexModel>> searchMoexAssets(String query) => moexApiClient.searchMoexAssets(query);

  Future<List<SearchCoinmarketcapModel>> getCoinmarketcapAssets() => cmcApiClient.getCoinmarketcapAssets();

  Future<List<OhlcvModel>> getMoexAssetHistory({
    required SearchMoexModel asset,
    required MoexAssetHistoryInterval interval,
    required int nCandles,
  }) =>
      moexApiClient.getMoexAssetHistory(
        asset: asset,
        interval: interval,
        nCandles: nCandles,
      );

  Future<MoexModelWithMarketData?> getMoexAssetWithMarketData(SearchMoexModel asset) => moexApiClient.getMoexAssetWithMarketData(asset);
}
