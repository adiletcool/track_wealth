import 'package:get/get.dart';

import '../../data/enums/market_types.dart';
import '../../data/model/asset/asset_model.dart';
import '../../data/model/asset/coinmarketcap/coinmarketcap_model.dart';
import '../../data/model/asset/moex/moex_model.dart';
import '../../data/repository/asset_repository.dart';

class AssetSearchController extends GetxController {
  final AssetRepository assetRepository;

  AssetSearchController(this.assetRepository);

  final Rx<MarketType> selectedMarketType = MarketType.all.obs;
  void selectMarketType(MarketType marketType) => selectedMarketType.value = marketType;

  List<SearchCoinmarketcapModel> cmcCryptocurrencies = [];

  @override
  Future<void> onReady() async {
    super.onReady();

    cmcCryptocurrencies = await assetRepository.getCoinmarketcapAssets();
  }

  // Search Field
  RxString searchQuery = ''.obs;
  List<SearchMoexModel> suggestedMoexAssets = [];
  Set<SearchCoinmarketcapModel> suggestedCrypto = {};

  RxSet<AssetModel> suggestedAssets = <AssetModel>{}.obs;

  Set<AssetModel> get filteredSuggestedAssets {
    switch (selectedMarketType.value) {
      case MarketType.all:
        return suggestedAssets;
      default:
        return suggestedAssets.where((asset) => asset.assetType == AssetType.values.byName(selectedMarketType.value.name)).toSet();
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
        suggestedMoexAssets = await assetRepository.searchMoexAssets(query);

        // first match by slug then by name
        suggestedCrypto = cmcCryptocurrencies.where((c) => c.symbol.toLowerCase().contains(query.toLowerCase())).toSet();
        suggestedCrypto.addAll(cmcCryptocurrencies.where((c) => c.name.toLowerCase().contains(query.toLowerCase())));

        suggestedAssets = <AssetModel>{...suggestedMoexAssets, ...suggestedCrypto}.obs;
        return true;
      }
      return true;
    });
  }
}
