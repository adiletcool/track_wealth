abstract class AssetChartInterval {
  final AssetChartCandleTimeFrame candleTF;
  final int nCandles;
  final String title;

  AssetChartInterval(this.candleTF, this.nCandles, this.title);
}

abstract class AssetChartCandleTimeFrame {}

class MoexAssetCandleTimeFrame extends AssetChartCandleTimeFrame {
  final int queryInterval;
  MoexAssetCandleTimeFrame(this.queryInterval);

  MoexAssetCandleTimeFrame.hour() : queryInterval = 60;
  MoexAssetCandleTimeFrame.day() : queryInterval = 24;
  MoexAssetCandleTimeFrame.week() : queryInterval = 7;
  MoexAssetCandleTimeFrame.month() : queryInterval = 31;
  MoexAssetCandleTimeFrame.quarter() : queryInterval = 4;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MoexAssetCandleTimeFrame && other.queryInterval == queryInterval;
  }

  @override
  int get hashCode => queryInterval.hashCode;
}

class MoexAssetChartInterval extends AssetChartInterval {
  MoexAssetCandleTimeFrame get moexCandleTF => candleTF as MoexAssetCandleTimeFrame;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MoexAssetChartInterval && other.moexCandleTF == moexCandleTF && other.nCandles == nCandles && other.title == title;
  }

  @override
  int get hashCode => moexCandleTF.hashCode ^ nCandles.hashCode ^ title.hashCode;

  /// Day: 24 hourly candle
  MoexAssetChartInterval.day() : super(MoexAssetCandleTimeFrame.hour(), 24, '24h');

  /// Week: 7*24 hourly candles
  MoexAssetChartInterval.week() : super(MoexAssetCandleTimeFrame.hour(), 7 * 24, '7d');

  /// Month: 30 daily candles
  MoexAssetChartInterval.month() : super(MoexAssetCandleTimeFrame.day(), 30, '30d');

  /// Season (30d): 90 daily candles
  MoexAssetChartInterval.quarter() : super(MoexAssetCandleTimeFrame.day(), 90, '90d');

  /// Year: 52 weekly candles
  MoexAssetChartInterval.year() : super(MoexAssetCandleTimeFrame.week(), 52, '1Y');

  /// 5 Years: 12*5 monthly candles
  MoexAssetChartInterval.fiveYears() : super(MoexAssetCandleTimeFrame.month(), 12 * 5, '5Y');

  static List<MoexAssetChartInterval> all() {
    return [
      MoexAssetChartInterval.day(),
      MoexAssetChartInterval.week(),
      MoexAssetChartInterval.month(),
      MoexAssetChartInterval.quarter(),
      MoexAssetChartInterval.year(),
      MoexAssetChartInterval.fiveYears(),
    ];
  }
}
