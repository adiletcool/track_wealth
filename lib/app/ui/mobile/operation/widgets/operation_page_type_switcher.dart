import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:track_wealth/app/controllers/operation/operation_controller.dart';

import '../../../theme/app_color.dart';

class OperationPageTypeSwitcher<T extends OperationController> extends GetView<T> {
  const OperationPageTypeSwitcher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: controller.actions
              .map((a) => OperationTypeButton(
                    action: a,
                    isSelected: a == controller.selectedAction.value,
                    onTap: controller.selectAction,
                  ))
              .toList(),
        ));
  }
}

class OperationTypeButton extends StatelessWidget {
  final String action;
  final bool isSelected;
  final void Function(String action) onTap;

  const OperationTypeButton({
    required this.action,
    required this.isSelected,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: InkWell(
        onTap: () => onTap(action),
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 2,
                color: isSelected ? blueColor : transparentGreyColor,
              ),
            ),
          ),
          child: Center(
            child: Text(
              action.tr,
              style: context.textTheme.headlineSmall?.copyWith(fontSize: 17),
            ),
          ),
        ),
      ),
    );
  }
}
