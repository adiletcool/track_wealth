import '../../enums/market_types.dart';
import 'asset_model.dart';

class SearchCryptoModel implements AssetModel {
  final String ticker;
  final String cmcId;
  final String cmcSlug;
  final String shortName;

  @override
  String? get imageUrl => null;

  @override
  AssetType get assetType => AssetType.crypto;

  SearchCryptoModel({
    required this.ticker,
    required this.cmcId,
    required this.cmcSlug,
    required this.shortName,
  });

  @override
  String get subtitle => ticker;

  @override
  String get displayName => shortName;

  Map<String, String> toMap() => {
        "ticker": ticker,
        "cmcId": cmcId,
        "cmcSlug": cmcSlug,
        "shortName": shortName,
      };

  SearchCryptoModel.fromMap(Map<String, dynamic> map)
      : ticker = map['ticker'],
        cmcId = map['cmcId'],
        cmcSlug = map['cmcSlug'],
        shortName = map['shortName'];
}
