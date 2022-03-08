import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:track_wealth/app/ui/mobile/widgets/sliver_fill_column.dart';

import '../../../controllers/home/home_controller.dart';
import 'widgets/home_page_appbar.dart';

class HomePage extends GetView<HomePageController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      slivers: <Widget>[
        HomePageAppBar(),
        HomePageBody(),
      ],
    );
  }
}

class HomePageBody extends StatelessWidget {
  const HomePageBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SliverFillColumn(
      children: [
        Text('Home'),
      ],
    );
  }
}
