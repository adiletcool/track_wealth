import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:track_wealth/app/data/model/asset_chart/coinmarketcap_chart_interval.dart';

import '../../../../controllers/asset/asset_page_controller.dart';
import '../../../../data/enums/market_types.dart';
import '../../../../data/model/asset_chart/asset_chart_interval.dart';
import '../../../../data/model/asset_chart/moex_chart_interval.dart';
import '../../../theme/app_color.dart';

class AssetPageIntervalRow extends GetView<AssetPageController> {
  const AssetPageIntervalRow({Key? key}) : super(key: key);

  List<AssetChartInterval> get intervals {
    switch (controller.asset.assetType) {
      case AssetType.stocks:
        return MoexChartInterval.all();

      case AssetType.crypto:
        return CoinmarketcapChartInterval.all();

      default:
        throw UnimplementedError();
    }
  }

  double get intervalWidth {
    return (Get.width - 32) / (intervals.length * 1.25);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            height: 26,
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: ThemeBasedColor(context, greyColor, greyColor2).withOpacity(.4),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: intervals.map((i) {
                    return AssetPageIntervalButton(
                      interval: i,
                      isSelected: controller.chart.interval.value == i,
                      width: intervalWidth,
                      onTap: () => controller.chart.setInterval(i),
                    );
                  }).toList(),
                )),
          ),
        ),
        SizedBox(
          height: 26 + 16,
          child: Obx(() => IconButton(
                splashRadius: 20,
                onPressed: controller.chart.changeType,
                icon: controller.chart.type.value == ChartType.candlestick
                    ? SvgPicture.asset('assets/icons/candlestick_chart.svg', color: context.theme.iconTheme.color)
                    : const Icon(Icons.timeline_rounded),
              )),
        ),
      ],
    );
  }
}

class AssetPageIntervalButton extends StatelessWidget {
  final AssetChartInterval interval;
  final bool isSelected;
  final double width;
  final void Function() onTap;

  const AssetPageIntervalButton({
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
          color: isSelected ? (ThemeBasedColor(context, context.theme.colorScheme.primary, Colors.yellow)).withOpacity(.5) : null,
        ),
        child: Text(
          interval.title.tr,
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? ThemeBasedColor(context, Colors.black, Colors.white) : null,
          ),
        ),
      ),
    );
  }
}
