import 'package:get/state_manager.dart';

abstract class OperationController extends GetxController {
  List<String> get actions;
  RxString get selectedAction;

  void selectAction(String action);

  void addOperation();
}
