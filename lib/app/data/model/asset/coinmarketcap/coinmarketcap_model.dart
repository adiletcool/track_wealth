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
  final num lastPrice;
  final num dayChangePercent;
  final num dayVolume;
  final num? marketCapitalization;
  final String mdDescription;

  @override
  int get priceDecimals {
    if (lastPrice >= 10) return 2;
    if (lastPrice >= 1) return 3;

    String expA = lastPrice.toStringAsExponential(3);
    int exp = int.parse(expA.split('e-').last);

    if (exp > 10) return 10; // to small number, better just show 0.00...0
    return 3 + exp;
  }

  String get lastPriceRepr => lastPrice.toStringAsFixed(priceDecimals);

  CoinmarketcapModelWithMarketData.fromMap(Map<String, dynamic> map)
      : lastPrice = map['statistics']['price'],
        dayChangePercent = map['statistics']['priceChangePercentage24h'],
        marketCapitalization = map['statistics']['marketCap'],
        dayVolume = map['volume'],
        mdDescription = map['description'],
        super.fromMap(map);

  @override
  String get updateTime => DateFormat.yMMMd(Get.deviceLocale?.languageCode).add_Hms().format(DateTime.now());
}
