import '../../enums/market_types.dart';
import 'asset_model.dart';

enum StockPrimaryBoardId { tqbr, fqbr }

class SearchStockModel extends SearchMoexModel {
  SearchStockModel.fromMap(Map<String, dynamic> map) : super.fromMap(map);

  StockPrimaryBoardId get stockPrimaryBoardId => StockPrimaryBoardId.values.byName(primaryBoardId.toLowerCase());

  @override
  AssetType get assetType => AssetType.stocks;

  @override
  String? get imageUrl => isin == null ? null : 'https://invest-brands.cdn-tinkoff.ru/${isin}x160.png';

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

  StockModelWithMarketData.fromMap(Map<String, dynamic> map)
      : lastPrice = map['LASTPRICE'],
        todayChangePercent = map['todayChangePercent'],
        todayChangeNominal = map['todayChangeNominal'],
        priceDecimals = map['priceDecimals'],
        lotSize = map['lotSize'],
        updateTime = map['updateTime'],
        marketCapitalization = map['marketCapitalization'],
        super.fromMap(map);
}
