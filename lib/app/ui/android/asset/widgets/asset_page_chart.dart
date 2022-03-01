import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../controllers/asset/asset_page_controller.dart';
import '../../../../data/model/asset_chart/ohlcv_model.dart';
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

class AssetPageHistoryChart extends GetView<AssetPageController> {
  const AssetPageHistoryChart({Key? key}) : super(key: key);

  Future<List<CartesianSeries<OhlcvModel, DateTime>>> _getCandleSeries(List<OhlcvModel> assetHistory) async {
    return await compute(_computeCandleSeries, ComputeCandleSeriesParams(assetHistory, 'price'.tr, 'volume'.tr));
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => FutureBuilder(
          future: controller.isChartLoading.value,
          builder: (context, AsyncSnapshot<void> snapshot) {
            if ((snapshot.connectionState == ConnectionState.waiting)) {
              return const SizedBox(
                child: LoadingWidget(),
                height: 200,
              );
            }
            return FutureBuilder(
              future: _getCandleSeries(controller.assetChart),
              builder: (context, AsyncSnapshot<List<CartesianSeries<OhlcvModel, DateTime>>> snapshot) {
                if ((snapshot.connectionState == ConnectionState.waiting) || !snapshot.hasData) {
                  return const SizedBox(
                    child: LoadingWidget(),
                    height: 200,
                  );
                }
                return SfCartesianChart(
                  onChartTouchInteractionDown: (_) => controller.setTrackballVisibility(true),
                  onChartTouchInteractionUp: (_) => controller.setTrackballVisibility(false),
                  onTrackballPositionChanging: (TrackballArgs args) {
                    int? index = args.chartPointInfo.dataPointIndex;
                    if (index != null) controller.setTrackballIndex(index);
                  },
                  trackballBehavior: TrackballBehavior(
                    enable: true,
                    activationMode: ActivationMode.singleTap,
                    lineDashArray: const [5, 5],
                    lineColor: Colors.grey.shade500,
                    tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
                    // builder: (BuildContext context, TrackballDetails details) {details.groupingModeInfo}
                    // builder: (BuildContext context, TrackballDetails details) {
                    //   return TrackballTooltip(details);
                    // },
                  ),
                  series: snapshot.data,
                  plotAreaBorderWidth: 0,
                  borderWidth: 0,
                  margin: const EdgeInsets.only(left: 10),
                  axes: [
                    NumericAxis(
                      name: 'volume',
                      isVisible: false,
                      maximum: controller.assetChart.map((i) => i.volume).reduce(math.max).toDouble() * 5,
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
                    dateFormat: DateFormat.MMMd(Get.deviceLocale?.languageCode),
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
        ));
  }
}

class TrackballTooltip extends GetView<AssetPageController> {
  final TrackballDetails details;
  const TrackballTooltip(this.details, {Key? key}) : super(key: key);

  int? get _index => details.pointIndex;
  bool get isFalling {
    return _index == 0 ? false : controller.assetChart[_index!].close > controller.assetChart[_index! - 1].close;
  }

  Color get _color => isFalling ? redBrightColor : greenBrightColor;

  @override
  Widget build(BuildContext context) {
    if (_index == null) return Container();

    return Center(
      child: Row(
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: _color,
              shape: BoxShape.circle,
            ),
          ),
          Column(
            children: [
              Text('high'.tr + ': ' + controller.assetChart[_index!].high.toString()),
              Text('low'.tr + ': ' + controller.assetChart[_index!].low.toString()),
              Text('open'.tr + ': ' + controller.assetChart[_index!].open.toString()),
              Text('close'.tr + ': ' + controller.assetChart[_index!].close.toString()),
            ],
          ),
        ],
      ),
    );
  }
}
