import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/asset/asset_page_controller.dart';
import '../widgets/loading_widget.dart';
import 'widgets/asset_page_appbar.dart';
import 'widgets/asset_page_chart.dart';
import 'widgets/asset_page_interval_row.dart';
import 'widgets/asset_page_md_row.dart';
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
        child: Column(
          children: const [
            AssetPageMarketDataRow(),
            AssetPageIntervalSwitcher(),
            SizedBox(height: 10),
            AssetPageHistoryChart(),
          ],
        ),
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
          crossFadeState: controller.trackballVisible.value ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        ));
  }
}
