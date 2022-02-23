import 'package:get/get.dart';

import '../../constants/show_snackbars.dart';
import '../enums/market_types.dart';
import '../enums/moex_enums.dart';
import '../model/asset/asset_model.dart';
import '../model/asset/bond_model.dart';
import '../model/asset/currency_model.dart';
import '../model/asset/stock_model.dart';
import '../model/asset_history/ohlcv_model.dart';

class MoexApiClient extends GetConnect {
  static String base = "https://iss.moex.com";

  Future<List<SearchMoexModel>> searchMoexAssets(String query) async {
    /// Returns list of stocks, bonds and currencies (SearchStockModel and SearchBondModel)
    if (query.length >= 2) {
      var url = "$base/iss/securities.json";
      Map<String, String> params = {"q": query, "iss.meta": "on"};

      var response = await get(url, query: params);

      if (response.statusCode != 200) {
        showDefaultSnackbar(message: response.statusCode.toString(), title: 'error'.tr);
        return [];
      }

      List securitiesKeys = response.body["securities"]["columns"];
      List securitiesData = response.body["securities"]["data"];

      List<Map<String, dynamic>> securities = List.generate(securitiesData.length, (index) {
        return Map<String, dynamic>.fromIterables(List<String>.from(securitiesKeys), securitiesData[index]);
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

  Future<List<OhlcvModel>> getMoexAssetHistory({
    required SearchMoexModel asset,
    required MoexAssetHistoryInterval interval,
    int nCandles = 500,
  }) async {
    if (nCandles <= 0) {
      showDefaultSnackbar(message: 'Period must be positive'.tr, title: 'error'.tr);
      return [];
    }

    String url;
    Map<String, dynamic> params;

    switch (asset.assetType) {
      case AssetType.stocks:
        SearchStockModel stock = asset as SearchStockModel;

        String sharesType = stock.stockPrimaryBoardId == StockPrimaryBoardId.tqbr ? 'shares' : 'foreignshares';
        int boardGroups = stock.stockPrimaryBoardId == StockPrimaryBoardId.tqbr ? 57 : 265;
        int _interval = _getInterval(interval);

        url = "$base/cs/engines/stock/markets/$sharesType/boardgroups/$boardGroups/securities/${stock.secId}.hs";
        params = {"s1.type": "candles", "interval": _interval, "candles": nCandles};
        break;

      case AssetType.currencies:
        url = '';
        params = {};
        throw UnimplementedError(); // TODO: Handle getMoexAssetHistory for AssetType.currencies

      default:
        throw 'Not a moex asset type: ${asset.assetType}';
    }
    var response = await get(url, query: params);

    List? candles = response.body['candles'];
    List volumes = response.body['volumes'];

    if (candles == null || candles.isEmpty) {
      showDefaultSnackbar(message: 'Unknown error while loading: $url\n$params', title: 'error'.tr);
      return [];
    }

    List<List<num>> ohlc = candles.first['data']; // [[1645488000000, 79.99, 80.97, 78.49, 78.8], ...]
    List<List<num>> volume = volumes.first['data']; // [[1645488000000, 478201000000], ...]

    List<OhlcvModel> result = List.generate(
      ohlc.length,
      (index) => OhlcvModel(
        timestamp: ohlc[index][0].toInt(),
        open: ohlc[index][1],
        high: ohlc[index][2],
        low: ohlc[index][3],
        close: ohlc[index][4],
        volume: volume[index][1],
      ),
    );
    return result;
  }

  int _getInterval(MoexAssetHistoryInterval interval) {
    switch (interval) {
      case MoexAssetHistoryInterval.m1:
        return 1;
      case MoexAssetHistoryInterval.m10:
        return 10;
      case MoexAssetHistoryInterval.h:
        return 60;
      case MoexAssetHistoryInterval.d:
        return 24;
      case MoexAssetHistoryInterval.w:
        return 7;
      case MoexAssetHistoryInterval.M:
        return 31;
      case MoexAssetHistoryInterval.Q:
        return 4;
    }
  }
}
