import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/asset/asset_page_controller.dart';
import '../widgets/loading_widget.dart';
import '../widgets/sliver_fill_column.dart';
import 'widgets/asset_page_appbar.dart';
import 'widgets/asset_page_chart.dart';
import 'widgets/asset_page_interval_row.dart';
import 'widgets/asset_page_md_row.dart';
import 'widgets/asset_page_operation_button.dart';
import 'widgets/asset_page_statistics.dart';
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
    return SliverFillColumn(
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
