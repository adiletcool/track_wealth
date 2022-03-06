import 'asset_chart_interval.dart';

class MoexAssetCandleTimeFrame extends AssetChartCandleTimeFrame {
  MoexAssetCandleTimeFrame.hour() : super("60");
  MoexAssetCandleTimeFrame.day() : super("24");
  MoexAssetCandleTimeFrame.week() : super("7");
  MoexAssetCandleTimeFrame.month() : super("31");
  MoexAssetCandleTimeFrame.quarter() : super("4");
}

class MoexChartInterval extends AssetChartInterval {
  final int nCandles;

  MoexAssetCandleTimeFrame get moexCandleTF => candleTF as MoexAssetCandleTimeFrame;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MoexChartInterval && other.moexCandleTF == moexCandleTF && other.nCandles == nCandles && other.title == title;
  }

  @override
  int get hashCode => moexCandleTF.hashCode ^ nCandles.hashCode ^ title.hashCode;

  /// Day: 24 hourly candle
  MoexChartInterval.day()
      : nCandles = 24,
        super(MoexAssetCandleTimeFrame.hour(), '24h');

  /// Week: 7*24 hourly candles
  MoexChartInterval.week()
      : nCandles = 7 * 24,
        super(MoexAssetCandleTimeFrame.hour(), '7d');

  /// Month: 30 daily candles
  MoexChartInterval.month()
      : nCandles = 30,
        super(MoexAssetCandleTimeFrame.day(), '30d');

  /// Season (30d): 90 daily candles
  MoexChartInterval.quarter()
      : nCandles = 90,
        super(MoexAssetCandleTimeFrame.day(), '90d');

  /// Year: 52 weekly candles
  MoexChartInterval.year()
      : nCandles = 52,
        super(MoexAssetCandleTimeFrame.week(), '1Y');

  /// 5 Years: 12*5 monthly candles
  MoexChartInterval.fiveYears()
      : nCandles = 12 * 5,
        super(MoexAssetCandleTimeFrame.month(), '5Y');

  static List<MoexChartInterval> all() {
    return [
      MoexChartInterval.day(),
      MoexChartInterval.week(),
      MoexChartInterval.month(),
      MoexChartInterval.quarter(),
      MoexChartInterval.year(),
      MoexChartInterval.fiveYears(),
    ];
  }
}
