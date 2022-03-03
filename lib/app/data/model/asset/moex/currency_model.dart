import '../../../enums/market_types.dart';
import 'moex_model.dart';

class SearchCurrencyModel extends SearchMoexModel {
  SearchCurrencyModel.fromMap(Map<String, dynamic> map) : super.fromMap(map);

  @override
  AssetType get assetType => AssetType.currencies;

  @override
  String? get imageUrl => 'https://invest-brands.cdn-tinkoff.ru/${secId.substring(0, 3)}x160.png';

  static fromListOfMaps(List<Map<String, dynamic>> listOfMaps) {
    return listOfMaps.map((Map<String, dynamic> m) {
      return SearchCurrencyModel.fromMap(m);
    }).toList();
  }
}

class CurrencyModelWithMarketData extends MoexModelWithMarketData {
  CurrencyModelWithMarketData.fromMap(Map<String, dynamic> map) : super.fromMap(map);

  @override
  AssetType get assetType => AssetType.currencies;

  @override
  String? get imageUrl => null;
}
