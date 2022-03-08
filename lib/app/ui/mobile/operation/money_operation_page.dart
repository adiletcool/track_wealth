import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/operation/money_operation_controller.dart';
import '../widgets/sliver_fill_column.dart';
import 'widgets/operation_page_appbar.dart';
import 'widgets/operation_page_type_switcher.dart';

class MoneyOperationPage extends GetView<MoneyOperationPageController> {
  const MoneyOperationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            OperationPageAppBar('money'.tr),
            const MoneyOperationPageBody(),
          ],
        ),
      ),
    );
  }
}

class MoneyOperationPageBody extends StatelessWidget {
  const MoneyOperationPageBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SliverFillColumn(
      children: [
        OperationPageTypeSwitcher<MoneyOperationPageController>(),
      ],
    );
  }
}
