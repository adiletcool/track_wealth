import '../../enums/market_types.dart';
import 'asset_model.dart';

class SearchStockModel implements AssetModel {
  final String? isin;
  final String primaryBoardId;
  final String secId;
  final String shortName;
  final String name;

  @override
  String? get imageUrl => isin == null ? null : 'https://invest-brands.cdn-tinkoff.ru/${isin}x160.png';

  @override
  String get subtitle => secId;

  @override
  String get displayName => shortName;

  @override
  AssetType get assetType => AssetType.stocks;

  SearchStockModel({
    required this.isin,
    required this.primaryBoardId,
    required this.secId,
    required this.shortName,
    required this.name,
  });

  Map<String, dynamic> toMap() => {
        "isin": isin,
        "primary_boardid": primaryBoardId,
        "secid": secId,
        "shortname": shortName,
        "name": name,
      };

  SearchStockModel.fromMap(Map<String, dynamic> map)
      : isin = map['isin'],
        primaryBoardId = map['primary_boardid'],
        secId = map['secid'],
        shortName = map['shortname'],
        name = map['name'];

  static fromListOfMaps(List<Map<String, dynamic>> listOfMaps) {
    return listOfMaps.map((Map<String, dynamic> m) {
      return SearchStockModel.fromMap(m);
    }).toList();
  }
}

class StockModelWithMarketData extends SearchStockModel {
  final num lastPrice;
  final num todayChangePercent;
  final num todayChangeNominal;
  final int priceDecimals;

  final int lotSize;

  final String updateTime;
  final num? marketCapitalization;

  StockModelWithMarketData({
    required this.lastPrice,
    required this.todayChangePercent,
    required this.todayChangeNominal,
    required this.priceDecimals,
    required this.lotSize,
    required this.updateTime,
    this.marketCapitalization,
    required String isin,
    required String primaryBoardId,
    required String secId,
    required String shortName,
    required String name,
  }) : super(
          isin: isin,
          primaryBoardId: primaryBoardId,
          secId: secId,
          shortName: shortName,
          name: name,
        );
}
