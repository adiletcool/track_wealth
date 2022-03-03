import 'package:intl/intl.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../controllers/asset/asset_page_controller.dart';
import '../../../../data/model/asset_chart/ohlcv_model.dart';
import '../../../../utils/formatters.dart';
import '../../../theme/app_color.dart';
import '../../widgets/loading_widget.dart';

class ComputeCandleSeriesParams {
  final List<OhlcvModel> series;
  final String priceSeriesName;
  final String volumeSeriesName;

  ComputeCandleSeriesParams(this.series, this.priceSeriesName, this.volumeSeriesName);
}

List<CartesianSeries<OhlcvModel, DateTime>> _computeCandleSeries(ComputeCandleSeriesParams params) {
  // priceSeriesName & volumeSeriesName can not be loaded from translations because it is isolated func
  return <CartesianSeries<OhlcvModel, DateTime>>[
    CandleSeries(
      name: params.priceSeriesName,
      yAxisName: 'price',
      bullColor: greenBrightColor,
      bearColor: redBrightColor,
      enableSolidCandles: true,
      dataSource: params.series,
      xValueMapper: (OhlcvModel ohlcv, _) => DateTime.fromMillisecondsSinceEpoch(ohlcv.timestamp),
      lowValueMapper: (OhlcvModel ohlcv, _) => ohlcv.low,
      highValueMapper: (OhlcvModel ohlcv, _) => ohlcv.high,
      openValueMapper: (OhlcvModel ohlcv, _) => ohlcv.open,
      closeValueMapper: (OhlcvModel ohlcv, _) => ohlcv.close,
    ),
    // Volume
    ColumnSeries(
      name: params.volumeSeriesName,
      yAxisName: 'volume',
      dataSource: params.series,
      xValueMapper: (OhlcvModel ohlcv, _) => DateTime.fromMillisecondsSinceEpoch(ohlcv.timestamp),
      yValueMapper: (OhlcvModel ohlcv, _) => ohlcv.volume,
      borderRadius: BorderRadius.circular(10),
      opacity: .5,
    ),
  ];
}

class AssetPageChart extends GetView<AssetPageController> {
  const AssetPageChart({Key? key}) : super(key: key);

  Future<List<CartesianSeries<OhlcvModel, DateTime>>> _getCandleSeries(List<OhlcvModel> assetHistory) async {
    return await compute(_computeCandleSeries, ComputeCandleSeriesParams(assetHistory, 'price'.tr, 'volume'.tr));
  }

  @override
  Widget build(BuildContext context) {
    // return Container(color: Colors.red, height: 300);
    return SizedBox(
      height: 300,
      child: Obx(() => FutureBuilder(
            future: controller.chart.isLoading.value,
            builder: (context, AsyncSnapshot<void> snapshot) {
              if ((snapshot.connectionState == ConnectionState.waiting)) {
                return const LoadingWidget();
              }
              return FutureBuilder(
                future: _getCandleSeries(controller.chart.data),
                builder: (context, AsyncSnapshot<List<CartesianSeries<OhlcvModel, DateTime>>> snapshot) {
                  if ((snapshot.connectionState == ConnectionState.waiting) || !snapshot.hasData) {
                    return const LoadingWidget();
                  }
                  return SfCartesianChart(
                    onChartTouchInteractionDown: (_) => controller.chart.setTrackballVisibility(true),
                    onChartTouchInteractionUp: (_) => controller.chart.setTrackballVisibility(false),
                    onTrackballPositionChanging: (TrackballArgs args) {
                      int? index = args.chartPointInfo.dataPointIndex;
                      if (index != null) controller.chart.setTrackballIndex(index);
                    },
                    trackballBehavior: TrackballBehavior(
                      enable: true,
                      activationMode: ActivationMode.singleTap,
                      lineDashArray: const [5, 5],
                      lineColor: Colors.grey.shade500,
                      tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
                      builder: (BuildContext context, TrackballDetails trackballDetails) =>
                          TrackballTooltip(trackballDetails, controller.chart.xAxisDateFormat.value),
                    ),
                    series: snapshot.data,
                    plotAreaBorderWidth: 0,
                    borderWidth: 0,
                    margin: const EdgeInsets.only(left: 10),
                    axes: [
                      NumericAxis(
                        name: 'volume',
                        isVisible: false,
                        maximum: controller.chart.maxVolume * 5,
                      ),
                    ],
                    primaryXAxis: DateTimeCategoryAxis(
                      rangePadding: ChartRangePadding.none,
                      desiredIntervals: 4,
                      labelPosition: ChartDataLabelPosition.inside,
                      majorTickLines: const MajorTickLines(width: 0),
                      tickPosition: TickPosition.inside,
                      majorGridLines: const MajorGridLines(width: 0),
                      opposedPosition: true,
                      dateFormat: controller.chart.xAxisDateFormat.value,
                    ),
                    primaryYAxis: NumericAxis(
                      name: 'price',
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
                },
              );
            },
          )),
    );
  }
}

class TrackballTooltip extends StatelessWidget {
  final TrackballDetails details;
  final DateFormat dateFormat;
  const TrackballTooltip(this.details, this.dateFormat, {Key? key}) : super(key: key);

  CartesianChartPoint? get candle => details.groupingModeInfo?.points[0];
  CartesianChartPoint? get volume => details.groupingModeInfo?.points[1];

  bool get isFalling => candle?.close > candle?.open;

  Color get _color => isFalling ? greenBrightColor : redBrightColor;

  @override
  Widget build(BuildContext context) {
    if (candle == null) return Container();
    return IntrinsicWidth(
      child: IntrinsicHeight(
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            backgroundBlendMode: BlendMode.darken,
            color: ThemeBasedColor(context, Colors.grey.shade800, Colors.black).withOpacity(.7),
            // shape: BoxShape.circle,
          ),
          child: Center(
            child: Row(
              children: [
                Container(width: 8, decoration: BoxDecoration(color: _color, shape: BoxShape.circle)),
                const SizedBox(width: 10),
                Text(
                  dateFormat.format(candle!.x) +
                      '\n\n' +
                      'high'.tr +
                      ' : ' +
                      candle!.high.toString() +
                      '\n' +
                      'low'.tr +
                      ' : ' +
                      candle!.low.toString() +
                      '\n' +
                      'open'.tr +
                      ' : ' +
                      candle!.open.toString() +
                      '\n' +
                      'close'.tr +
                      ' : ' +
                      candle!.close.toString() +
                      '\n' +
                      'volume'.tr +
                      ' : ' +
                      double.parse(volume!.yValue.toString()).compactFormat(),
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
