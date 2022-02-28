import 'dart:convert';

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
      Map<String, String> params = {"q": query, "iss.meta": "off", "lang": Get.locale?.languageCode ?? 'en'};

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
    required int nCandles,
  }) async {
    String url;
    Map<String, dynamic> params;

    switch (asset.assetType) {
      case AssetType.stocks:
        SearchStockModel stock = asset as SearchStockModel;

        String sharesType = stock.stockPrimaryBoardId == StockPrimaryBoardId.tqbr ? 'shares' : 'foreignshares';
        int boardGroups = stock.stockPrimaryBoardId == StockPrimaryBoardId.tqbr ? 57 : 265;
        int _interval = _getInterval(interval);

        url = "$base/cs/engines/stock/markets/$sharesType/boardgroups/$boardGroups/securities/${stock.secId}.hs";
        params = {"s1.type": "candles", "interval": _interval.toString(), "candles": nCandles.toString()};
        break;

      case AssetType.bonds:
      case AssetType.currencies:
        url = '';
        params = {};
        throw UnimplementedError(); // TODO: Handle getMoexAssetHistory for currencies and bonds

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

    // [[1645488000000, 79.99, 80.97, 78.49, 78.8], ...]
    List<List<num>> ohlc = List.generate(candles.first['data'].length, (index) => List<num>.from(candles.first['data'][index]));
    // [[1645488000000, 478201000000], ...]
    List<List<num>> volume = List.generate(volumes.first['data'].length, (index) => List<num>.from(volumes.first['data'][index]));

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

  Future<MoexModelWithMarketData?> getMoexAssetWithMarketData(SearchMoexModel asset) async {
    // sample
    // https://iss.moex.com/iss/engines/currency/markets/selt/boards/CETS/securities/USD000UTSTOM.jsonp?iss.meta=off&iss.only=marketdata,securities&lang=ru
    // https://iss.moex.com/iss/engines/stock/markets/shares/boards/TQBR/securities/SBER.jsonp?iss.meta=off&iss.only=marketdata,securities&lang=ru
    String url;
    Map<String, String> params = {
      "iss.meta": "off",
      "iss.only": "marketdata,securities",
      "lang": Get.locale?.languageCode ?? 'en',
    };

    switch (asset.assetType) {
      case AssetType.stocks:
        asset as SearchStockModel;
        String shares = asset.stockPrimaryBoardId == StockPrimaryBoardId.tqbr ? "shares" : "foreignshares";
        url = '$base/iss/engines/stock/markets/$shares/boards/${asset.primaryBoardId}/securities/${asset.secId}.jsonp';

        var response = await get(url, query: params);

        if (response.statusCode != 200) {
          showDefaultSnackbar(message: response.statusCode.toString(), title: 'error'.tr);
          return null;
        }
        Map<String, dynamic> result = Map<String, dynamic>.from(json.decode(response.body));
        Map<String, List<dynamic>> marketdata = Map<String, List<dynamic>>.from(result['marketdata']);
        Map<String, List<dynamic>> securities = Map<String, List<dynamic>>.from(result['securities']);

        if (marketdata['data']!.isNotEmpty) {
          Map<String, dynamic> marketdataAsMap = Map.fromIterables(List<String>.from(marketdata['columns']!), marketdata['data']!.first);
          Map<String, dynamic> securitiesAsMap = Map.fromIterables(List<String>.from(securities['columns']!), securities['data']!.first);

          Map<String, dynamic> joinedMap = {}
            ..addAll(marketdataAsMap)
            ..addAll(securitiesAsMap);

          StockModelWithMarketData stock = StockModelWithMarketData.fromMap(joinedMap);
          return stock;
        }
        return null;

      case AssetType.bonds:
        throw UnimplementedError();

      case AssetType.currencies:
        url = '$base/iss/currency/currency/markets/selt/boards/${asset.primaryBoardId}/securities';
        throw UnimplementedError(); // TODO: Handle getMoexAssetMarketData for currencies and bonds

      default:
        throw 'Not a moex asset type: ${asset.assetType}';
    }
  }
}
