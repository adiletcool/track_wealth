import 'package:track_wealth/app/data/provider/coinmarketcap_api.dart';

import '../model/asset/stock_model.dart';
import '../provider/moex_api.dart';

class AssetRepository {
  final MoexApiClient moexApiClient;
  final CoinmarketcapApiClient cmcApiClient;

  AssetRepository({required this.moexApiClient, required this.cmcApiClient});

  Future<List<SearchStockModel>> searchStocks(String query) => moexApiClient.searchStocks(query);
}
