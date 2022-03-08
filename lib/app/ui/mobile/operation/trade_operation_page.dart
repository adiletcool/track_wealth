import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/operation/trade_operation_controller.dart';
import '../widgets/sliver_fill_column.dart';
import 'widgets/operation_page_appbar.dart';
import 'widgets/operation_page_button.dart';
import 'widgets/operation_page_type_switcher.dart';
import 'widgets/trade_operation_page_summary.dart';
import 'widgets/trade_operation_page_textfields.dart';

class TradeOperationPage extends GetView<TradeOperationPageController> {
  const TradeOperationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            OperationPageAppBar(controller.mdAsset.displayName),
            const TradeOperationPageBody(),
          ],
        ),
      ),
    );
  }
}

class TradeOperationPageBody extends GetView<TradeOperationPageController> {
  const TradeOperationPageBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverFillColumn(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            OperationPageTypeSwitcher<TradeOperationPageController>(),
            SizedBox(height: 10),
            TradeOperationPageSummary(),
            SizedBox(height: 10),
            Divider(height: 20),
            TradeOperationPageTextFields(),
          ],
        ),
        const OperationPageAddButton<TradeOperationPageController>(),
      ],
    );
  }
}
