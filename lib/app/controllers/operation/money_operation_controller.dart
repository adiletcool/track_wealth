import 'package:get/get.dart';
import 'package:track_wealth/app/controllers/operation/operation_controller.dart';
import 'package:track_wealth/app/data/enums/operation.dart';

class MoneyOperationPageController extends OperationController {
  MoneyOperationPageController();

  @override
  late List<String> actions;

  @override
  RxString selectedAction = MoneyAction.deposit.name.obs;

  @override
  void selectAction(String action) => selectedAction.value = action;

  @override
  void addOperation() {
    // TODO
  }

  @override
  void onInit() {
    actions = [
      MoneyAction.deposit,
      MoneyAction.withdrawal,
      MoneyAction.revenue,
      MoneyAction.expense,
    ].map((e) => e.name).toList();

    super.onInit();
  }
}
