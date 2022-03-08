import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/operation/trade_operation_controller.dart';

class TradeOperationPageSummary extends GetView<TradeOperationPageController> {
  const TradeOperationPageSummary({Key? key}) : super(key: key);

  String get totalAction => controller.isPurchase ? 'write_off'.tr : 'receive'.tr;
  String get totalTitle => 'total'.tr + '\n' + totalAction + ': ' + controller.data.operationTotalFormatted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.mdAsset.displayName,
                  style: context.textTheme.headline6?.copyWith(fontSize: 22),
                ),
                const SizedBox(height: 8),
                Text(
                  totalTitle,
                  style: context.textTheme.headline6?.copyWith(fontSize: 15),
                ),
              ],
            )),
      ),
    );
  }
}
