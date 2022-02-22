import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'market_section.dart';

class AssetSearchPreset extends StatelessWidget {
  const AssetSearchPreset({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          const SizedBox(height: 20),
          MarketSection(
            title: 'russian stock market'.tr,
            stocks: {
              MarketSectionCardWithStocks(
                title: 'finance'.tr,
                stocks: const [],
              ),
              MarketSectionCardWithStocks(
                title: 'energy'.tr,
                stocks: const [],
              ),
            },
          ),
        ],
      ),
    );
  }
}
