import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/asset/asset_page_controller.dart';

class AssetPageTrackballDate extends GetView<AssetPageController> {
  const AssetPageTrackballDate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Obx(() => Container(
              height: 26,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
              child: Center(
                child: Text(controller.trackballDate),
              ),
            )),
      ],
    );
  }
}
