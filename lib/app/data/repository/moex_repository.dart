import '../model/asset/stock_model.dart';
import '../provider/moex_api.dart';

class MoexRepository {
  final MoexApiClient moexApiClient;

  MoexRepository({required this.moexApiClient});

  Future<List<SearchStockModel>> searchStocks(String query) => moexApiClient.searchStocks(query);
}
