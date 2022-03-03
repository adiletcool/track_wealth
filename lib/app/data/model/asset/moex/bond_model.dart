import '../../../enums/market_types.dart';
import 'moex_model.dart';

class SearchBondModel extends SearchMoexModel {
  SearchBondModel.fromMap(Map<String, dynamic> map) : super.fromMap(map);

  @override
  AssetType get assetType => AssetType.bonds;

  @override
  String? get imageUrl => null;

  static fromListOfMaps(List<Map<String, dynamic>> listOfMaps) {
    return listOfMaps.map((Map<String, dynamic> m) {
      return SearchBondModel.fromMap(m);
    }).toList();
  }
}

class BondModelWithMarketData extends MoexModelWithMarketData {
  BondModelWithMarketData.fromMap(Map<String, dynamic> map) : super.fromMap(map);

  @override
  AssetType get assetType => AssetType.bonds;

  @override
  String? get imageUrl => null;
}
