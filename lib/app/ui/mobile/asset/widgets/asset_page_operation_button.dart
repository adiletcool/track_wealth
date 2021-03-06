import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:track_wealth/app/controllers/asset/asset_page_controller.dart';
import 'package:track_wealth/app/routes/app_pages.dart';

import '../../../theme/app_color.dart';

class AssetPageOperationButton extends GetView<AssetPageController> {
  const AssetPageOperationButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () => Get.toNamed(Routes.tradeOperation, arguments: controller.mdAsset),
        child: Container(
          height: 55,
          width: context.width - 80,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.white),
            borderRadius: BorderRadius.circular(30),
            color: ThemeBasedColor(context, Colors.black, Colors.white),
          ),
          child: Center(
            child: Text(
              'add_operation'.tr,
              style: TextStyle(fontSize: 19, color: ThemeBasedColor(context, Colors.white, Colors.black)),
            ),
          ),
        ),
      ),
    );
  }
}
