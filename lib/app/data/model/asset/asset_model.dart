abstract class AssetModel {
  final String displayName;
  final String subtitle;

  AssetModel({
    required this.displayName,
    required this.subtitle,
  });
}

abstract class SearchAssetModel extends AssetModel {
  final num lastPrice;
  final int priceDecimals;
  final num todayChangePercent;
  final num todayChangeNominal;
  final String imageUrl;

  SearchAssetModel({
    required this.lastPrice,
    required this.priceDecimals,
    required this.todayChangePercent,
    required this.todayChangeNominal,
    required this.imageUrl,
    required String displayName,
    required String subtitle,
  }) : super(
          displayName: displayName,
          subtitle: subtitle,
        );
}
