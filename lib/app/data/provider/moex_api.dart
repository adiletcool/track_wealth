import 'package:get/get.dart';

import '../model/asset/stock_model.dart';

class MoexApiClient extends GetConnect {
  Future<List<SearchStockModel>> searchStocks(String query) async {
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

      var stocks = securities.where((sec) => ["stock_shares", "stock_dr"].contains(sec['group']) && ['TQBR', 'FQBR'].contains(sec['primary_boardid'])).toList();
      // var bonds = securities.where((sec) => sec['group'] == 'stock_bonds').toList();

      List<SearchStockModel> foundStocks = SearchStockModel.fromListOfMaps(stocks);
      return foundStocks;
    }
    return [];
  }
}
