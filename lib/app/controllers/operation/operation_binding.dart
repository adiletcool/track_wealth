import 'package:get/get.dart';

import 'money_operation_controller.dart';
import 'trade_operation_controller.dart';

class TradeOperationPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TradeOperationPageController>(() => TradeOperationPageController());
  }
}

class MoneyOperationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MoneyOperationPageController>(() => MoneyOperationPageController());
  }
}
