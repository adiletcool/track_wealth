import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../data/model/asset_history/ohlcv_model.dart';
import '../../../theme/app_color.dart';
import '../../widgets/loading_widget.dart';

List<CandleSeries<OhlcvModel, DateTime>> _computeCandleSeries(List<OhlcvModel> series) {
  return <CandleSeries<OhlcvModel, DateTime>>[
    CandleSeries(
      bullColor: greenBrightColor,
      bearColor: redBrightColor,
      enableSolidCandles: true,
      dataSource: series,
      xValueMapper: (OhlcvModel ohlcv, _) => DateTime.fromMillisecondsSinceEpoch(ohlcv.timestamp),
      lowValueMapper: (OhlcvModel ohlcv, _) => ohlcv.low,
      highValueMapper: (OhlcvModel ohlcv, _) => ohlcv.high,
      openValueMapper: (OhlcvModel ohlcv, _) => ohlcv.open,
      closeValueMapper: (OhlcvModel ohlcv, _) => ohlcv.close,
    ),
  ];
}

class AssetPageHistoryChart extends StatelessWidget {
  final List<OhlcvModel> assetHistory;

  const AssetPageHistoryChart({Key? key, required this.assetHistory}) : super(key: key);

  Future<List<CandleSeries<OhlcvModel, DateTime>>> _getCandleSeries() async {
    return await compute(_computeCandleSeries, assetHistory);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getCandleSeries(),
        builder: (context, AsyncSnapshot<List<CandleSeries<OhlcvModel, DateTime>>> snapshot) {
          if ((snapshot.connectionState == ConnectionState.waiting) || !snapshot.hasData) {
            return const LoadingWidget();
          }
          return SfCartesianChart(
            onTrackballPositionChanging: (TrackballArgs args) {
              int? index = args.chartPointInfo.dataPointIndex;
              if (index != null) {
                var ts = assetHistory[index].timestamp;
                var dt = DateTime.fromMillisecondsSinceEpoch(ts);
                // Send to controller. Load value from another widget through controller => change ui
                print(dt);
              }
            },
            series: snapshot.data,
            plotAreaBorderWidth: 0,
            borderWidth: 0,
            margin: const EdgeInsets.only(left: 10),
            trackballBehavior: TrackballBehavior(
              enable: true,
              activationMode: ActivationMode.singleTap,
              lineDashArray: const [5, 5],
              lineColor: Colors.grey.shade500,
            ),
            primaryXAxis: DateTimeCategoryAxis(
              rangePadding: ChartRangePadding.none,
              desiredIntervals: 4,
              labelPosition: ChartDataLabelPosition.inside,
              majorTickLines: const MajorTickLines(width: 0),
              tickPosition: TickPosition.inside,
              majorGridLines: const MajorGridLines(width: 0),
              opposedPosition: true,
              dateFormat: DateFormat.MMMd(),
            ),
            primaryYAxis: NumericAxis(
              axisLine: const AxisLine(width: 0),
              edgeLabelPlacement: EdgeLabelPlacement.hide,
              tickPosition: TickPosition.inside,
              majorTickLines: const MajorTickLines(width: 0),
              minorTickLines: const MinorTickLines(width: 0),
              opposedPosition: true,
              rangePadding: ChartRangePadding.round,
              // minimum: (assetHistory.map((e) => e.low).reduce(math.min) * 0.85).toPrecision(1),
              // maximum: (assetHistory.map((e) => e.low).reduce(math.max) * 1.15).toPrecision(1),
            ),
          );
        });
  }
}
