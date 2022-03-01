import 'dart:convert';

abstract class AssetHistoryInterval {
  final String title;

  AssetHistoryInterval(this.title);
}

// TODO: REFACTOR THIS: For moex combine queryInt and nCandles to get 24h, 7d, 30d, 90d, 1y
class MoexAssetHistoryInterval extends AssetHistoryInterval {
  final int qInt;
  final int nCandles;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MoexAssetHistoryInterval && other.qInt == qInt && other.nCandles == nCandles && other.title == title;
  }

  @override
  int get hashCode => qInt.hashCode ^ nCandles.hashCode;

  MoexAssetHistoryInterval(this.qInt, this.nCandles, String title) : super(title);

  /// Day: 24 hourly candle
  MoexAssetHistoryInterval.d()
      : qInt = 60,
        nCandles = 24,
        super('24h');

  /// Week: 7*24 hourly candles
  MoexAssetHistoryInterval.w()
      : qInt = 60,
        nCandles = 7 * 24,
        super('7d');

  /// Month: 30 daily candles
  MoexAssetHistoryInterval.M()
      : qInt = 24,
        nCandles = 30,
        super('30d');

  /// Season (30d): 90 daily candles
  MoexAssetHistoryInterval.S()
      : qInt = 24,
        nCandles = 90,
        super('90d');

  /// Year: 12 monthly candles
  MoexAssetHistoryInterval.Y()
      : qInt = 31,
        nCandles = 12,
        super('1Y');

  static List<MoexAssetHistoryInterval> all() {
    return [
      MoexAssetHistoryInterval.d(),
      MoexAssetHistoryInterval.w(),
      MoexAssetHistoryInterval.M(),
      MoexAssetHistoryInterval.S(),
      MoexAssetHistoryInterval.Y(),
    ];
  }
}
