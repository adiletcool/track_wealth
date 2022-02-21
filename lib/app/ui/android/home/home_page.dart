import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/home/home_controller.dart';
import 'widgets/home_page_appbar.dart';
import 'widgets/home_page_body.dart';

class HomePage extends GetView<HomeController> {
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
