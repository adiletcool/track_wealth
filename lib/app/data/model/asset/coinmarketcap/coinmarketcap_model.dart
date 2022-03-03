import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../enums/market_types.dart';
import '../asset_model.dart';

class SearchCoinmarketcapModel implements AssetModel {
  final int id;
  final String name;
  final String slug;
  final String symbol;

  @override
  String? get imageUrl => 'https://s2.coinmarketcap.com/static/img/coins/64x64/$id.png';

  @override
  AssetType get assetType => AssetType.crypto;

  SearchCoinmarketcapModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.symbol,
  });

  @override
  String get subtitle => symbol;

  @override
  String get displayName => name;

  SearchCoinmarketcapModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        slug = map['slug'],
        symbol = map['symbol'];

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "slug": slug,
        "symbol": symbol,
      };

  static fromListOfMaps(List<Map<String, dynamic>> listOfMaps) {
    return listOfMaps.map((Map<String, dynamic> m) {
      return SearchCoinmarketcapModel.fromMap(m);
    }).toList();
  }
}

class CoinmarketcapModelWithMarketData extends SearchCoinmarketcapModel implements AssetModelWithMarketData {
  CoinmarketcapModelWithMarketData.fromMap(Map<String, dynamic> map) : super.fromMap(map);

  @override
  String get updateTime => DateFormat.yMMMd(Get.deviceLocale?.languageCode).add_Hms().format(DateTime.now());
}
