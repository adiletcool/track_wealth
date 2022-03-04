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
  final ChartType chartType;
  final String priceSeriesName;
  final String volumeSeriesName;
  final Color lineColor;

  ComputeCandleSeriesParams(
    this.series,
    this.chartType, {
    required this.priceSeriesName,
    required this.volumeSeriesName,
    required this.lineColor,
  });
}

List<CartesianSeries<OhlcvModel, DateTime>> _computeCandleSeries(ComputeCandleSeriesParams params) {
  // priceSeriesName & volumeSeriesName can not be loaded from translations because it is isolated func
  return <CartesianSeries<OhlcvModel, DateTime>>[
    params.chartType == ChartType.candlestick
        ? CandleSeries(
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
          )
        : SplineAreaSeries(
            name: params.priceSeriesName,
            yAxisName: 'price',
            dataSource: params.series,
            xValueMapper: (OhlcvModel ohlcv, _) => DateTime.fromMillisecondsSinceEpoch(ohlcv.timestamp),
            yValueMapper: (OhlcvModel ohlcv, _) => ohlcv.close,
            gradient: LinearGradient(
              colors: <Color>[Colors.transparent, params.lineColor.withOpacity(.2)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            borderWidth: 1,
            borderColor: params.lineColor,
            borderDrawMode: BorderDrawMode.top,
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

  Future<List<CartesianSeries<OhlcvModel, DateTime>>> _getCandleSeries(BuildContext context, List<OhlcvModel> assetHistory, ChartType chartType) async {
    return await compute(
      _computeCandleSeries,
      ComputeCandleSeriesParams(
        assetHistory,
        chartType,
        priceSeriesName: 'price'.tr,
        volumeSeriesName: 'volume'.tr,
        lineColor: ThemeBasedColor(context, context.theme.colorScheme.primary, Colors.yellow).withOpacity(0.7),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Obx(() => FutureBuilder(
            future: controller.chart.isLoading.value,
            builder: (context, AsyncSnapshot<void> snapshot) {
              if ((snapshot.connectionState == ConnectionState.waiting)) {
                return const LoadingWidget();
              }
              return Obx(() => FutureBuilder(
                    future: _getCandleSeries(context, controller.chart.data, controller.chart.type.value),
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
                              TrackballTooltip(trackballDetails, controller.chart.xAxisDateFormat.value, controller.chart.type.value),
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
                  ));
            },
          )),
    );
  }
}

class TrackballTooltip extends StatelessWidget {
  final TrackballDetails details;
  final DateFormat dateFormat;
  final ChartType chartType;
  const TrackballTooltip(this.details, this.dateFormat, this.chartType, {Key? key}) : super(key: key);

  CartesianChartPoint? get data => details.groupingModeInfo?.points[0];
  CartesianChartPoint? get volume => details.groupingModeInfo?.points[1];

  bool get isCandle => chartType == ChartType.candlestick;

  bool? get isFalling => isCandle ? data?.close > data?.open : null;

  Color? get _circleColor => isCandle ? (isFalling! ? greenBrightColor : redBrightColor) : null;

  String getDataString() {
    return '\n\n' +
        (isCandle
            ? 'high'.tr +
                ' : ' +
                data!.high.toString() +
                '\n' +
                'low'.tr +
                ' : ' +
                data!.low.toString() +
                '\n' +
                'open'.tr +
                ' : ' +
                data!.open.toString() +
                '\n' +
                'close'.tr +
                ' : ' +
                data!.close.toString()
            : 'price'.tr + ' : ' + data!.yValue.toString()) +
        '\n' +
        'volume'.tr +
        ' : ';
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) return Container();
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
                if (isCandle) ...[
                  Container(width: 8, decoration: BoxDecoration(color: _circleColor, shape: BoxShape.circle)),
                  const SizedBox(width: 10),
                ],
                Text(
                  dateFormat.format(data!.x) + getDataString() + double.parse(volume!.yValue.toString()).compactFormat(),
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
