import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:track_wealth/app/routes/app_pages.dart';

import 'home_page_search.dart';

class HomePageAppBar extends StatelessWidget {
  const HomePageAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      backgroundColor: context.theme.scaffoldBackgroundColor,
      actions: [
        IconButton(
          icon: SvgPicture.asset('assets/icons/wallet2.svg', color: context.theme.iconTheme.color, width: 22),
          onPressed: () => Get.toNamed(Routes.moneyOperation),
        ),
        IconButton(
          icon: SvgPicture.asset('assets/icons/search.svg', color: context.theme.iconTheme.color),
          onPressed: () {
            showSearch(
              context: context,
              delegate: AssetSearchDelegate(),
            );
          },
        )
      ],
    );
  }
}
