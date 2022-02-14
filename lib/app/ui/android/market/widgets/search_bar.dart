import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/market/market_controller.dart';
import '../../../theme/app_color.dart';

class MarketPageSearchBar extends GetView<MarketController> {
  const MarketPageSearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: clear button
    return SizedBox(
      height: 45,
      child: Center(
        child: Obx(() => TextField(
              controller: controller.search.searchController.value,
              focusNode: controller.search.searchFocusNode.value,
              maxLines: 1,
              autocorrect: false,
              textAlignVertical: TextAlignVertical.center,
              style: const TextStyle(fontSize: 17),
              onChanged: (_) => controller.search.update(),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 18),
                hintText: 'search'.tr,
                filled: true,
                fillColor: transparentGreyColor,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(15),
                ),
                suffixIcon: controller.search.searchController.value.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: controller.search.clear,
                        color: darkGreyColor,
                      ),
              ),
            )),
      ),
    );
  }
}
