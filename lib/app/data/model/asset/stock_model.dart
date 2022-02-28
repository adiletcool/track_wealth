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

class StockModelWithMarketData extends MoexModelWithMarketData {
  final num lastPrice;
  final num dayChangePercent;
  final num dayChangeNominal;
  final int priceDecimals;

  final int lotSize;

  final String updateTime;
  final num? marketCapitalization;
  final num dayVolume;

  @override
  AssetType get assetType => AssetType.stocks;

  @override
  String? get imageUrl => isin == null ? null : 'https://invest-brands.cdn-tinkoff.ru/${isin}x160.png';

  StockModelWithMarketData.fromMap(Map<String, dynamic> map)
      : lastPrice = map['LAST'] ?? map['MARKETPRICE'],
        dayChangePercent = map['LASTTOPREVPRICE'],
        dayChangeNominal = map['CHANGE'],
        priceDecimals = map['DECIMALS'],
        lotSize = map['LOTSIZE'],
        updateTime = map['UPDATETIME'],
        marketCapitalization = map['ISSUECAPITALIZATION'],
        dayVolume = map['VALTODAY'],
        super.fromMap(map);
}
