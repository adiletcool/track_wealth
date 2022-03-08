import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/dashboard/dashboard_controller.dart';
import 'home/home_page.dart';
import 'history/history_page.dart';
import 'profile/profile_page.dart';

class DashboardPage extends GetView<DashboardPageController> {
  DashboardPage({Key? key}) : super(key: key);

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: SafeArea(
            child: IndexedStack(
              index: controller.tabIndex.value,
              children: const [
                HomePage(),
                HistoryPage(),
                ProfilePage(),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: controller.tabIndex.value,
            onTap: controller.changeTab,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'home'),
              BottomNavigationBarItem(icon: Icon(Icons.segment_rounded), label: 'home'),
              BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'profile'),
            ],
          ),
        ));
  }
}
