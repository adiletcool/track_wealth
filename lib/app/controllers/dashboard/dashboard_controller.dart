import 'package:get/get.dart';

class DashboardPageController extends GetxController {
  RxInt tabIndex = 0.obs;

  void changeTab(int index) => tabIndex.value = index;
}
