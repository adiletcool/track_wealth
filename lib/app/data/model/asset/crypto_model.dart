import 'asset_model.dart';

class CryptoModel implements AssetModel {
  final String ticker;
  final String cmcId;
  final String cmcSlug;
  final String shortName;

  CryptoModel({
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

  CryptoModel.fromMap(Map<String, dynamic> map)
      : ticker = map['ticker'],
        cmcId = map['cmcId'],
        cmcSlug = map['cmcSlug'],
        shortName = map['shortName'];
}
