import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:track_wealth/app/ui/theme/app_color.dart';

import '../../../controllers/asset/asset_page_controller.dart';
import '../../../data/enums/market_types.dart';
import '../../../data/model/asset_history/asset_history_interval.dart';
import '../../../data/model/asset_history/ohlcv_model.dart';
import '../widgets/loading_widget.dart';
import 'widgets/asset_page_appbar.dart';
import 'widgets/asset_page_chart.dart';
import 'widgets/asset_page_md_row.dart';

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
            const AssetPageMarketDataRow(),
            const AssetPageIntervalRow(),
            const SizedBox(height: 10),
            AssetPageHistoryChart(assetHistory: assetHistory),
          ],
        ),
      ),
    );
  }
}

class AssetPageIntervalRow extends GetView<AssetPageController> {
  const AssetPageIntervalRow({Key? key}) : super(key: key);

  List<AssetHistoryInterval> get intervals {
    switch (controller.asset.assetType) {
      case AssetType.stocks:
        return MoexAssetHistoryInterval.all();
      default:
        throw UnimplementedError();
    }
  }

  double get intervalWidth {
    return (Get.width - 32) / (intervals.length * 1.25);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: ThemeBasedColor(context, greyColor, greyColor2).withOpacity(.4),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: intervals.map((i) {
              return AssetHistoryIntervalButton(
                interval: i,
                isSelected: controller.chartInterval.value == i,
                width: intervalWidth,
                onTap: () => controller.setChartInterval(i),
              );
            }).toList(),
          )),
    );
  }
}

class AssetHistoryIntervalButton extends StatelessWidget {
  final AssetHistoryInterval interval;
  final bool isSelected;
  final double width;
  final void Function() onTap;

  const AssetHistoryIntervalButton({
    Key? key,
    required this.interval,
    required this.isSelected,
    required this.width,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: isSelected ? (ThemeBasedColor(context, Get.theme.colorScheme.primary, Colors.yellow)).withOpacity(.5) : null,
        ),
        child: Text(
          interval.title,
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? ThemeBasedColor(context, Colors.black, Colors.white) : null,
          ),
        ),
      ),
    );
  }
}
