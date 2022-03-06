import 'package:get/get.dart';

import 'asset_chart_interval.dart';

class CoinmarketcapCandleTimeFrame extends AssetChartCandleTimeFrame {
  CoinmarketcapCandleTimeFrame.hourly() : super('hourly');
  CoinmarketcapCandleTimeFrame.daily() : super('daily');

  // resample
  CoinmarketcapCandleTimeFrame.fourHourly() : super('');
  CoinmarketcapCandleTimeFrame.weekly() : super('');
}

class CoinmarketcapChartInterval extends AssetChartInterval {
  final Duration timeDifference;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CoinmarketcapChartInterval && other.timeDifference == timeDifference && other.candleTF == candleTF && other.title == title;
  }

  @override
  int get hashCode => candleTF.hashCode ^ candleTF.hashCode ^ title.hashCode;

  int get timeStart => now.subtract(timeDifference).millisecondsSinceEpoch ~/ 1000;

  int get timeEnd => now.millisecondsSinceEpoch ~/ 1000;

  DateTime get now => DateTime.now().toUtc().subtract(1.hours);

  int get nowTs => now.millisecondsSinceEpoch ~/ 1000;

  CoinmarketcapChartInterval.day()
      : timeDifference = const Duration(hours: 25),
        super(CoinmarketcapCandleTimeFrame.hourly(), '24h');

  CoinmarketcapChartInterval.week()
      : timeDifference = const Duration(days: 8),
        super(CoinmarketcapCandleTimeFrame.hourly(), '7d');

  CoinmarketcapChartInterval.month()
      : timeDifference = const Duration(days: 31),
        super(CoinmarketcapCandleTimeFrame.daily(), '30d');

  CoinmarketcapChartInterval.quarter()
      : timeDifference = const Duration(days: 91),
        super(CoinmarketcapCandleTimeFrame.daily(), '90d');

  CoinmarketcapChartInterval.year()
      : timeDifference = const Duration(days: 366),
        super(CoinmarketcapCandleTimeFrame.daily(), '1Y');

  static List<CoinmarketcapChartInterval> all() {
    return [
      CoinmarketcapChartInterval.day(),
      CoinmarketcapChartInterval.week(),
      CoinmarketcapChartInterval.month(),
      CoinmarketcapChartInterval.quarter(),
      CoinmarketcapChartInterval.year(),
    ];
  }
}
