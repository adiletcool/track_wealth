import 'package:get/get.dart';

import '../model/asset/asset_model.dart';
import '../model/asset/bond_model.dart';
import '../model/asset/currency_model.dart';
import '../model/asset/stock_model.dart';

class MoexApiClient extends GetConnect {
  Future<List<SearchMoexModel>> searchMoexAssets(String query) async {
    /// Returns list of stocks, bonds and currencies (SearchStockModel and SearchBondModel)
    if (query.length >= 2) {
      var url = "https://iss.moex.com/iss/securities.json";
      Map<String, String> params = {"q": query, "iss.meta": "on"};

      var response = await get(url, query: params);

      List securitiesKeys = response.body["securities"]["columns"];
      List securitiesData = response.body["securities"]["data"];

      List<Map<String, dynamic>> securities = List.generate(securitiesData.length, (index) {
        var stock = Map<String, dynamic>.fromIterables(List<String>.from(securitiesKeys), securitiesData[index]);

        return stock;
      });

      securities = securities.where((sec) => sec['is_traded'] == 1).toList(); // Filter only traded assets

      var stocks = securities.where((sec) => ["stock_shares", "stock_dr"].contains(sec['group']) && ['TQBR', 'FQBR'].contains(sec['primary_boardid'])).toList();
      var currencies = securities.where((sec) => (sec['group'] == 'currency_selt') && (sec['type'] == 'currency')).toList();
      var bonds = securities.where((sec) => sec['group'] == 'stock_bonds').toList();

      List<SearchStockModel> foundStocks = SearchStockModel.fromListOfMaps(stocks);
      List<SearchCurrencyModel> foundCurrencies = SearchCurrencyModel.fromListOfMaps(currencies);
      List<SearchBondModel> foundBonds = SearchBondModel.fromListOfMaps(bonds);

      List<SearchMoexModel> foundAssets = List<SearchMoexModel>.from([...foundStocks, ...foundCurrencies, ...foundBonds]);

      return foundAssets;
    }
    return [];
  }
}
