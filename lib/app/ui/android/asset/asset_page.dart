import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../controllers/asset/asset_page_controller.dart';
import '../../../data/enums/market_types.dart';
import '../../../data/model/asset/stock_model.dart';
import '../../../data/model/asset_history/ohlcv_model.dart';
import '../../theme/app_color.dart';
import '../widgets/loading_widget.dart';
import 'widgets/asset_page_appbar.dart';

class AssetPage extends GetView<AssetPageController> {
  const AssetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
            future: controller.initialLoad,
            builder: (context, AsyncSnapshot<void> snapshot) {
              if ((snapshot.connectionState == ConnectionState.waiting) || !snapshot.hasData) {
                return const LoadingWidget();
              }
              return CustomScrollView(
                slivers: [
                  AssetPageAppBar(controller.asset),
                  AssetPageBody(assetHistory: controller.assetHistory),
                ],
              );
            }),
      ),
    );
  }
}

class AssetPageBody extends StatelessWidget {
  final List<OhlcvModel> assetHistory;

  const AssetPageBody({Key? key, required this.assetHistory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(8.0),
      sliver: SliverFillRemaining(
        child: Column(
          children: [
            const AssetPageMarketData(),
            AssetPageHistoryChart(assetHistory: assetHistory),
          ],
        ),
      ),
    );
  }
}

class AssetPageMarketData extends GetView<AssetPageController> {
  const AssetPageMarketData({Key? key}) : super(key: key);

  Widget getBody(BuildContext context) {
    switch (controller.asset.assetType) {
      case AssetType.stocks:
        StockModelWithMarketData mdStock = controller.mdAsset as StockModelWithMarketData;
        bool isFalling = mdStock.dayChangeNominal < 0;
        Color subtitleColor = isFalling ? Colors.white : Colors.black;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    NumberFormat.currency(locale: 'ru', decimalDigits: mdStock.priceDecimals, symbol: '₽').format(mdStock.lastPrice),
                    style: Get.textTheme.headlineSmall,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: isFalling ? redBrightColor : greenBrightColor,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(isFalling ? Icons.south_east_rounded : Icons.north_east_rounded, size: 15, color: subtitleColor),
                        const SizedBox(width: 10),
                        Text(mdStock.dayChangeNominal.abs().toString(), style: TextStyle(color: subtitleColor, fontSize: 15)),
                        const SizedBox(width: 10),
                        Text('(${mdStock.dayChangeNominal.abs().toString()})', style: TextStyle(color: subtitleColor, fontSize: 15)),
                      ],
                    ),
                  ),
                ],
              ),
              Tooltip(
                showDuration: 5.seconds,
                message: 'volume24h'.tr +
                    ': ${NumberFormat.compact(locale: Get.locale?.languageCode).format(mdStock.dayVolume)}\n' +
                    'capitalization'.tr.tr +
                    ': ${NumberFormat.compact(locale: Get.locale?.languageCode).format(mdStock.marketCapitalization)}',
                child: Icon(
                  Icons.info_rounded,
                  size: 28,
                  color: ThemeBasedColor(context, Colors.black, Colors.white),
                ),
              ),
            ],
          ),
        );

      default:
        // TODO
        throw UnimplementedError();
    }
  }

  @override
  Widget build(BuildContext context) {
    return getBody(context);
  }
}

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
