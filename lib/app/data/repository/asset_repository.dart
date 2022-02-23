import '../model/asset/asset_model.dart';
import '../model/asset/crypto_model.dart';
import '../provider/coinmarketcap_api.dart';
import '../provider/moex_api.dart';

class AssetRepository {
  final MoexApiClient moexApiClient;
  final CoinmarketcapApiClient cmcApiClient;

  AssetRepository({required this.moexApiClient, required this.cmcApiClient});

  Future<List<SearchMoexModel>> searchMoexAssets(String query) => moexApiClient.searchMoexAssets(query);

  Future<List<SearchCoinmarketcapModel>> getCoinmarketcapAssets() => cmcApiClient.getCoinmarketcapAssets();
}
