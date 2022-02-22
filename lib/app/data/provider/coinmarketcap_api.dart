import 'package:get/get.dart';
import 'package:track_wealth/app/data/model/asset/crypto_model.dart';

class CoinmarketcapApiClient extends GetConnect {
// Get all active cryptocurrencies and cryptoexchanges

  @override
  void onInit() {}

  Future<List<SearchCoinmarketcapModel>> getCoinmarketcapAssets() async {
    /// Returns list of
    var response = await get('https://api.coinmarketcap.com/data-api/v3/map/all?listing_status=active&start=1&limit=10000');

    if (response.statusCode == 200) {
      var body = response.body;
      if (body['status']['error_code'] == "0") {
        Iterable<Map<String, dynamic>> cryptoMap = List<Map<String, dynamic>>.from(body['data']['cryptoCurrencyMap']);
        cryptoMap = cryptoMap.where((c) => c['symbol'] != null);

        return SearchCoinmarketcapModel.fromListOfMaps(cryptoMap.toList());
      } else {
        Get.showSnackbar(GetSnackBar(
          message: body['status']['error_message'],
          duration: 5.seconds,
          snackPosition: SnackPosition.TOP,
          title: 'error'.tr + ' ${body['status']['error_code']}',
        ));
      }
    } else {
      Get.showSnackbar(GetSnackBar(
        message: response.statusCode.toString(),
        duration: 5.seconds,
        snackPosition: SnackPosition.TOP,
        title: 'error'.tr,
      ));
    }

    return [];
  }
}
