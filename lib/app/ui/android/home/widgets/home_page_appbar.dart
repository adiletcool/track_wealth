import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
          icon: Icon(Icons.search_rounded, color: context.theme.iconTheme.color),
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
