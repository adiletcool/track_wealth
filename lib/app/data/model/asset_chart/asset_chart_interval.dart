abstract class AssetChartInterval {
  final AssetChartCandleTimeFrame candleTF;
  final String title;

  AssetChartInterval(this.candleTF, this.title);
}

abstract class AssetChartCandleTimeFrame {
  final String queryInterval;

  AssetChartCandleTimeFrame(this.queryInterval);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AssetChartCandleTimeFrame && other.queryInterval == queryInterval;
  }

  @override
  int get hashCode => queryInterval.hashCode;
}
