import 'package:get/get.dart';

class CoinmarketcapApiClient extends GetConnect {
// Get all active cryptocurrencies and cryptoexchanges

  @override
  void onInit() {}

  Future<Response> getCmcMap(int id) {
    return get('https://api.coinmarketcap.com/data-api/v3/map/all?listing_status=active&start=1&limit=10000');
  }
}
