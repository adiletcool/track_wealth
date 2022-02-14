import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:track_wealth/app/data/enums/market_types.dart';

import '../../../../controllers/market/market_controller.dart';
import '../../../theme/app_color.dart';
import 'search_bar.dart';
import 'package:get/get.dart';

class MarketPageHeader extends StatefulWidget {
  const MarketPageHeader({Key? key}) : super(key: key);

  @override
  State<MarketPageHeader> createState() => _MarketPageHeaderState();
}

class _MarketPageHeaderState extends State<MarketPageHeader> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: false,
      floating: true,
      delegate: MarketPageHeaderDelegate(this),
    );
  }
}

class MarketPageHeaderDelegate extends SliverPersistentHeaderDelegate {
  MarketPageHeaderDelegate(this.vsync);

  @override
  final TickerProvider vsync;

  @override
  double get minExtent => 125;

  @override
  double get maxExtent => 125;

  // Same behavior as SliverAppBar with snap: true
  @override
  FloatingHeaderSnapConfiguration get snapConfiguration => FloatingHeaderSnapConfiguration(
        curve: Curves.easeOut,
        duration: 200.milliseconds,
      );

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          MarketPageSearchBar(),
          MarketFiltersRow(),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class MarketFiltersRow extends GetView<MarketController> {
  const MarketFiltersRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
    );
  }
}

class MarketTypeFilter extends GetView<MarketController> {
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
            switch (context.isDarkMode) {
              case true:
                bgColor = Colors.white;
                textColor = Colors.black;
                break;
              default:
                bgColor = Colors.black;
                textColor = Colors.white;
                break;
            }
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
