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

abstract class AssetModelWithMarketData implements AssetModel {
  final String updateTime;

  AssetModelWithMarketData(this.updateTime);
}
