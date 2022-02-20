import 'package:flutter/material.dart';

import 'widgets/home_page_appbar.dart';
import 'widgets/home_page_body.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          controller: scrollController,
          slivers: const <Widget>[
            HomePageAppBar(),
            HomePageBody(),
          ],
        ),
      ),
    );
  }
}
