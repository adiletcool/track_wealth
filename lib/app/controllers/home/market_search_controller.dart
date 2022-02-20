import 'package:get/get.dart';

import '../../data/enums/market_types.dart';
import '../../data/model/asset/asset_model.dart';
import '../../data/model/asset/crypto_model.dart';
import '../../data/model/asset/stock_model.dart';
import '../../data/repository/moex_repository.dart';

class AssetSearchController extends GetxController {
  final MoexRepository moexRepository;

  AssetSearchController(this.moexRepository);

  final Rx<MarketType> selectedMarketType = MarketType.all.obs;

  void selectMarketType(MarketType marketType) => selectedMarketType.value = marketType;

  // Search Field
  RxString searchQuery = ''.obs;
  RxList<SearchStockModel> suggestedStocks = <SearchStockModel>[].obs;
  RxList<SearchCryptoModel> suggestedCrypto = <SearchCryptoModel>[].obs;

  RxList<AssetModel> suggestedAssets = <AssetModel>[].obs;

  List<AssetModel> get filteredSuggestedAssets {
    switch (selectedMarketType.value) {
      case MarketType.all:
        return suggestedAssets;
      default:
        return suggestedAssets.where((asset) => asset.assetType == AssetType.values.byName(selectedMarketType.value.name)).toList();
    }
  }

  void updateSearchQuery(String newVal) => searchQuery.value = newVal;
  void clearSearchQuery() {
    searchQuery.value = '';
    selectMarketType(MarketType.all);
  }

  Future<bool> getSearchSuggestion(String query) async {
    // Optimize use of moexApi: Search only if query wasn't changed after 200 msec
    return await Future.delayed(200.milliseconds).then((value) async {
      if (searchQuery.value == query) {
        suggestedStocks.value = await moexRepository.searchStocks(query);

        suggestedAssets.value = List<AssetModel>.from([...suggestedStocks, ...suggestedCrypto]);
        return true;
      }
      return true;
    });
  }
}
