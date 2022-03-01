abstract class AssetChartInterval {
  final String title;

  AssetChartInterval(this.title);
}

class MoexAssetChartInterval extends AssetChartInterval {
  final int qInt;
  final int nCandles;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MoexAssetChartInterval && other.qInt == qInt && other.nCandles == nCandles && other.title == title;
  }

  @override
  int get hashCode => qInt.hashCode ^ nCandles.hashCode;

  MoexAssetChartInterval(this.qInt, this.nCandles, String title) : super(title);

  /// Day: 24 hourly candle
  MoexAssetChartInterval.d()
      : qInt = 60,
        nCandles = 24,
        super('24h');

  /// Week: 7*24 hourly candles
  MoexAssetChartInterval.w()
      : qInt = 60,
        nCandles = 7 * 24,
        super('7d');

  /// Month: 30 daily candles
  MoexAssetChartInterval.M()
      : qInt = 24,
        nCandles = 30,
        super('30d');

  /// Season (30d): 90 daily candles
  MoexAssetChartInterval.S()
      : qInt = 24,
        nCandles = 90,
        super('90d');

  /// Year: 12 monthly candles
  MoexAssetChartInterval.Y()
      : qInt = 31,
        nCandles = 12,
        super('1Y');

  static List<MoexAssetChartInterval> all() {
    return [
      MoexAssetChartInterval.d(),
      MoexAssetChartInterval.w(),
      MoexAssetChartInterval.M(),
      MoexAssetChartInterval.S(),
      MoexAssetChartInterval.Y(),
    ];
  }
}
