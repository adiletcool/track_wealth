import 'package:get/get.dart';

class DashboardController extends GetxController {
  RxInt tabIndex = 0.obs;

  void changeTab(int index) => tabIndex.value = index;
}
