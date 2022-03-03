import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/home/asset_search_controller.dart';
import '../../../../data/enums/market_types.dart';
import '../../../theme/app_color.dart';

class MarketTypeFiltersRow extends GetView<AssetSearchController> {
  const MarketTypeFiltersRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        height: 35,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: MarketType.values.length,
          itemBuilder: (context, index) => MarketTypeFilter(
            marketType: MarketType.values[index],
            onTap: () => controller.selectMarketType(MarketType.values[index]),
          ),
          separatorBuilder: (context, index) => const SizedBox(width: 10),
        ),
      ),
    );
  }
}

class MarketTypeFilter extends GetView<AssetSearchController> {
  final void Function() onTap;
  final MarketType marketType;
  const MarketTypeFilter({
    Key? key,
    required this.onTap,
    required this.marketType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Obx(() {
        final Color bgColor;
        final Color textColor;

        switch (controller.selectedMarketType.value == marketType) {
          case true:
            bgColor = ThemeBasedColor(context, Colors.black, Colors.white);
            textColor = ThemeBasedColor(context, Colors.white, Colors.black);
            break;
          default:
            bgColor = transparentGreyColor;
            textColor = context.textTheme.bodyText1!.color!;
            break;
        }
        return Chip(
          label: Text(marketType.name.tr, style: TextStyle(color: textColor, fontWeight: FontWeight.w400)),
          backgroundColor: bgColor,
          padding: const EdgeInsets.symmetric(horizontal: 5),
        );
      }),
    );
  }
}
