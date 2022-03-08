import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/operation/trade_operation_controller.dart';
import '../../widgets/animated_switcher_with_transition.dart';
import 'operation_page_textfield.dart';

class TradeOperationPageTextFields extends GetView<TradeOperationPageController> {
  const TradeOperationPageTextFields({Key? key}) : super(key: key);
  String getPrefixSuffixText() => controller.isCrypto ? '\$' : '₽';

  @override
  Widget build(BuildContext context) {
    // TODO: add note textfield
    return Obx(() => AnimatedSwitcherWithTransition(
          showFirst: controller.isCrypto || (controller.isStock && !controller.isDividends),
          firstChild: Column(
            key: const Key('firstcolumn'),
            children: [
              OperationPageTextField(
                formKey: controller.data.priceFormKey,
                controller: controller.data.priceController.value,
                validate: controller.data.validatePrice,
                labelText: 'price'.tr,
                suffixText: getPrefixSuffixText(),
                onChanged: (_) => controller.updateData(),
                decimals: controller.assetPriceDecimals,
              ),
              OperationPageTextField(
                formKey: controller.data.quantityFormKey,
                controller: controller.data.quantityController.value,
                validate: controller.data.validateQuantity,
                labelText: 'quantity'.tr + ', ' + 'unit'.tr,
                suffixText: 'unit'.tr,
                counterText: '1 ${"lot".tr} = ${controller.assetLotSize} ${"unit".tr}',
                onChanged: (_) => controller.updateData(),
                onlyInteger: !controller.isCrypto,
                autofocus: true,
                decimals: controller.isCrypto ? 6 : controller.assetPriceDecimals,
              ),
              OperationPageTextField(
                formKey: controller.data.feeFormKey,
                controller: controller.data.feeController.value,
                labelText: 'fee'.tr,
                suffixText: getPrefixSuffixText(),
                onChanged: (_) => controller.updateData(),
                decimals: 6,
              ),
            ],
          ),
          secondChild: SizedBox(
            // TODO remove sizedbox
            height: 363,
            child: Column(
              children: [
                OperationPageTextField(
                  formKey: controller.data.dividendsFormKey,
                  controller: controller.data.dividendsController.value,
                  validate: controller.data.validateDividends,
                  labelText: 'amount'.tr,
                  suffixText: '₽',
                  onChanged: (_) => controller.updateData(isDividends: true),
                  decimals: 2,
                ),
                OperationPageTextField(
                  formKey: controller.data.divFeeFormKey,
                  controller: controller.data.divFeeController.value,
                  labelText: 'fee'.tr,
                  suffixText: '₽',
                  onChanged: (_) => controller.updateData(isDividends: true),
                  decimals: 6,
                ),
              ],
            ),
          ),
          firstChildKey: 'firstcolumn',
        ));
  }
}
