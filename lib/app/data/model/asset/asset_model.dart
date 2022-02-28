import '../../enums/market_types.dart';

abstract class AssetModel {
  final String displayName;
  final String subtitle;
  String? get imageUrl;

  final AssetType assetType;

  AssetModel({
    required this.displayName,
    required this.subtitle,
    required this.assetType,
  });
}

abstract class SearchMoexModel implements AssetModel {
  final String? isin;
  final String primaryBoardId;
  final String secId;
  final String shortName;
  final String name;

  @override
  String get subtitle => secId;

  @override
  String get displayName => shortName;

  SearchMoexModel.fromMap(Map<String, dynamic> map)
      : isin = map['isin'] ?? map['ISIN'],
        primaryBoardId = map['primary_boardid'] ?? map['BOARDID'],
        secId = map['secid'] ?? map['SECID'],
        shortName = map['shortname'] ?? map['SHORTNAME'],
        name = map['name'] ?? map['SECNAME'];

  Map<String, dynamic> toMap() => {
        "isin": isin,
        "primary_boardid": primaryBoardId,
        "secid": secId,
        "shortname": shortName,
        "name": name,
      };
}

abstract class MoexModelWithMarketData extends SearchMoexModel {
  MoexModelWithMarketData.fromMap(Map<String, dynamic> map) : super.fromMap(map);
}
