import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/asset/asset_page_controller.dart';
import '../../../../data/enums/market_types.dart';
import '../../../../data/model/asset/coinmarketcap/coinmarketcap_model.dart';
import '../../../../data/model/asset/moex/stock_model.dart';
import '../../../../utils/formatters.dart';

class AssetPageStatistics extends GetView<AssetPageController> {
  const AssetPageStatistics({Key? key}) : super(key: key);

  String _getStockStatistics({required num dayVolume, required num? marketCapitalization, String? symbol = '₽'}) {
    /// Daily volume and market capitalization
    String info = 'volume24h'.tr + ': ' + dayVolume.compactFormat() + ' $symbol';
    if (marketCapitalization != null) info += '\n' + 'capitalization'.tr + ': ' + marketCapitalization.compactFormat() + ' $symbol';
    return info;
  }

  Widget getBody() {
    switch (controller.asset.assetType) {
      case AssetType.stocks:
        StockModelWithMarketData mdStock = controller.mdAsset as StockModelWithMarketData;
        return Text(_getStockStatistics(dayVolume: mdStock.dayVolume, marketCapitalization: mdStock.marketCapitalization));

      case AssetType.crypto:
        CoinmarketcapModelWithMarketData mdCrypto = controller.mdAsset as CoinmarketcapModelWithMarketData;
        return Text(_getStockStatistics(dayVolume: mdCrypto.dayVolume, marketCapitalization: mdCrypto.marketCapitalization, symbol: '\$'));

      default:
        throw UnimplementedError(); // TODO
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('upd.'.tr + ': ' + controller.mdAsset!.updateTime, style: Get.textTheme.labelMedium),
          const SizedBox(height: 10),
          getBody(),
        ],
      ),
    );
  }
}
