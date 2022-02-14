import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:track_wealth/app/data/enums/market_types.dart';

class MarketController extends GetxController {
  final Rxn<MarketType> selectedMarketType = Rxn<MarketType>(); // nullable MarketType

  MarketSearch search = MarketSearch();

  void selectMarketType(MarketType marketType) {
    if (selectedMarketType.value == marketType) {
      return selectedMarketType.value = null;
    }
    selectedMarketType.value = marketType;
  }
}

class MarketSearch {
  Rx<TextEditingController> searchController = TextEditingController().obs;
  Rx<FocusNode> searchFocusNode = FocusNode().obs;

  void update() => searchController.refresh();
  void clear() => searchController.update((val) => val!.text = '');
}
