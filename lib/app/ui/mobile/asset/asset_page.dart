import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/asset/asset_page_controller.dart';
import '../../../data/enums/market_types.dart';
import '../../../data/model/asset/moex/stock_model.dart';
import '../../../utils/formatters.dart';
import '../widgets/loading_widget.dart';
import 'widgets/asset_page_appbar.dart';
import 'widgets/asset_page_chart.dart';
import 'widgets/asset_page_interval_row.dart';
import 'widgets/asset_page_md_row.dart';
import 'widgets/asset_page_operation_button.dart';
import 'widgets/asset_page_trackball_date.dart';

class AssetPage extends GetView<AssetPageController> {
  const AssetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (!controller.isInitalLoaded.value) {
            return const LoadingWidget();
          }
          return const CustomScrollView(
            slivers: [
              AssetPageAppBar(),
              AssetPageBody(),
            ],
          );
        }),
      ),
    );
  }
}

class AssetPageBody extends StatelessWidget {
  const AssetPageBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(8.0),
      sliver: SliverFillRemaining(
        hasScrollBody: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                AssetPageMarketDataRow(),
                AssetPageIntervalSwitcher(),
                SizedBox(height: 10),
                AssetPageChart(),
                AssetPageStatistics(),
              ],
            ),
            const AssetPageOperationButton(),
          ],
        ),
      ),
    );
  }
}

class AssetPageStatistics extends GetView<AssetPageController> {
  const AssetPageStatistics({Key? key}) : super(key: key);

  String _getStockStatistics({required num dayVolume, required num? marketCapitalization, String? symbol = '₽'}) {
    /// Daily volume and market capitalization
    String info = 'volume24h'.tr + ': ' + dayVolume.compactFormat() + ' $symbol';
    if (marketCapitalization != null) info += '\n' + 'capitalization'.tr + ': ' + marketCapitalization.compactFormat() + ' $symbol';
    return info;
  }

  Widget getBody() {
    switch (controller.asset.assetType) {
      case AssetType.stocks:
        StockModelWithMarketData mdStock = controller.mdAsset as StockModelWithMarketData;
        return Text(
          _getStockStatistics(dayVolume: mdStock.dayVolume, marketCapitalization: mdStock.marketCapitalization),
        );
      default:
        throw UnimplementedError(); // TODO
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('upd.'.tr + ': ' + controller.mdAsset!.updateTime, style: Get.textTheme.labelMedium),
          const SizedBox(height: 10),
          getBody(),
        ],
      ),
    );
  }
}

class AssetPageIntervalSwitcher extends GetView<AssetPageController> {
  const AssetPageIntervalSwitcher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => AnimatedCrossFade(
          duration: 200.milliseconds,
          firstChild: const AssetPageIntervalRow(),
          secondChild: const AssetPageTrackballDate(),
          crossFadeState: controller.chart.trackballVisible.value ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        ));
  }
}
