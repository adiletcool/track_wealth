import 'asset_model.dart';

class StockModel implements AssetModel {
  final String isin;
  final String boardId;
  final String secId;
  final String shortName;
  final String longName;
  final int lotSize;
  final int priceDecimals;

  @override
  String get subtitle => secId;

  @override
  String get displayName => shortName;

  StockModel({
    required this.isin,
    required this.boardId,
    required this.secId,
    required this.shortName,
    required this.longName,
    required this.lotSize,
    required this.priceDecimals,
  });

  Map<String, dynamic> toMap() => {
        "isin": isin,
        "boardId": boardId,
        "secId": secId,
        "shortName": shortName,
        "longName": longName,
        "lotSize": lotSize,
        "priceDecimals": priceDecimals,
      };

  StockModel.fromMap(Map<String, dynamic> map)
      : isin = map['isin'],
        boardId = map['boardId'],
        secId = map['secId'],
        shortName = map['shortName'],
        longName = map['longName'],
        lotSize = map['lotSize'],
        priceDecimals = map['priceDecimals'];
}

class SearchStockModel extends StockModel implements SearchAssetModel {
  @override
  final num lastPrice;
  @override
  final num todayChangePercent; // LASTTOPREVPRICE
  @override
  final num todayChangeNominal; // CHANGE

  final String updateTime; // UPDATETIME
  final num? marketCapitalization; // ISSUECAPITALIZATION

  @override
  String get imageUrl => 'https://invest-brands.cdn-tinkoff.ru/${isin}x160.png';

  SearchStockModel({
    required this.lastPrice,
    required this.todayChangePercent,
    required this.todayChangeNominal,
    required this.updateTime,
    this.marketCapitalization,
    required String isin,
    required String boardId,
    required String secId,
    required String shortName,
    required String longName,
    required int lotSize,
    required int priceDecimals,
  }) : super(
          isin: isin,
          boardId: boardId,
          secId: secId,
          shortName: shortName,
          longName: longName,
          lotSize: lotSize,
          priceDecimals: priceDecimals,
        );
}
