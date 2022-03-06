import 'package:get/get.dart';

import '../../constants/show_snackbars.dart';
import '../model/asset/coinmarketcap/coinmarketcap_model.dart';
import '../model/asset_chart/coinmarketcap_chart_interval.dart';
import '../model/asset_chart/ohlcv_model.dart';

class CoinmarketcapApiClient extends GetConnect {
  static String base = "https://api.coinmarketcap.com/data-api/v3";

  Future<List<SearchCoinmarketcapModel>> getCoinmarketcapAssets() async {
    /// Returns list of
    var response = await get('$base/map/all?listing_status=active&start=1&limit=10000');

    if (response.statusCode != 200) {
      showDefaultSnackbar(message: 'check_connection_try_again'.tr, title: 'no_internet_connection'.tr);
      return [];
    }

    var body = response.body;

    if (body['status']['error_code'] != "0") {
      showDefaultSnackbar(message: body['status']['error_message'], title: 'error'.tr + ' ${body['status']['error_code']}');
      return [];
    }

    Iterable<Map<String, dynamic>> cryptoMap = List<Map<String, dynamic>>.from(body['data']['cryptoCurrencyMap']);
    cryptoMap = cryptoMap.where((c) => c['symbol'] != null);

    return SearchCoinmarketcapModel.fromListOfMaps(cryptoMap.toList());
  }

  Future<CoinmarketcapModelWithMarketData?> getCoinmarketcapAssetWithMarketData(SearchCoinmarketcapModel asset) async {
    // sample
    // https://api.coinmarketcap.com/data-api/v3/cryptocurrency/detail?id=13216&langCode=ru

    String langCode = Get.deviceLocale?.languageCode ?? 'en';
    var response = await get('$base/cryptocurrency/detail?id=${asset.id}&langCode=$langCode');

    if (response.statusCode != 200) {
      showDefaultSnackbar(message: 'check_connection_try_again'.tr, title: 'no_internet_connection'.tr);
      return null;
    }

    var body = response.body;

    if (body['status']['error_code'] != "0") {
      showDefaultSnackbar(message: body['status']['error_message'], title: 'error'.tr + ' ${body['status']['error_code']}');
      return null;
    }

    return CoinmarketcapModelWithMarketData.fromMap(Map<String, dynamic>.from(body['data']));
  }

  Future<List<OhlcvModel>> getCoinmarketcapAssetChart({
    required SearchCoinmarketcapModel asset,
    required CoinmarketcapChartInterval interval,

    /// if false, quote volume is BTC
    bool quoteUSD = true,
  }) async {
    int convertId = quoteUSD ? 2781 : 1;

    String url = '$base/cryptocurrency/historical';
    Map<String, dynamic> params = {
      'id': asset.id.toString(),
      'convertId': convertId.toString(),
      'interval': interval.candleTF.queryInterval,
      'timeStart': interval.timeStart.toString(),
      'timeEnd': interval.timeEnd.toString(),
    };

    var response = await get(url, query: params);

    if (response.statusCode != 200) {
      showDefaultSnackbar(message: 'check_connection_try_again'.tr, title: 'no_internet_connection'.tr);
      return [];
    }

    var body = response.body;

    if (body['status']['error_code'] != "0") {
      showDefaultSnackbar(message: body['status']['error_message'], title: 'error'.tr + ' ${body['status']['error_code']}');
      return [];
    }
    List _data = response.body['data']['quotes'];
    List<Map<String, dynamic>> ohlcv = _data.map((e) => Map<String, dynamic>.from(e)).toList();

    if (ohlcv.isEmpty) {
      showDefaultSnackbar(message: 'Unknown error while loading: $url\n$params', title: 'error'.tr);
      return [];
    }

    Iterable<OhlcvModel> result = Iterable.generate(
      ohlcv.length,
      (index) => OhlcvModel(
        timestamp: DateTime.parse(ohlcv[index]['timeOpen']).millisecondsSinceEpoch,
        open: ohlcv[index]['quote']['open'],
        high: ohlcv[index]['quote']['high'],
        low: ohlcv[index]['quote']['low'],
        close: ohlcv[index]['quote']['close'],
        volume: ohlcv[index]['quote']['volume'],
      ),
    );

    // hourly to 4-hourly
    if (interval.title == '7d') return result.resample(combineBy: 4);

    // daily to weekly
    if (interval.title == '1Y') return result.resample(combineBy: 7);

    return result.toList();
  }
}
