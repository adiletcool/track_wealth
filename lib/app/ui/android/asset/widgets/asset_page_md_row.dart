import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/asset/asset_page_controller.dart';
import '../../../../data/enums/market_types.dart';
import '../../../../data/model/asset/stock_model.dart';
import '../../../../utils/formatters.dart';
import '../../../theme/app_color.dart';

class AssetPageMarketDataRow extends GetView<AssetPageController> {
  const AssetPageMarketDataRow({Key? key}) : super(key: key);

  Widget getCommonMdRow(
    BuildContext context, {
    required num dayChangeNominal,
    required num dayChangePercent,
    required int priceDecimals,
    required num lastPrice,
    required num dayVolume,
    required num? marketCapitalization,
  }) {
    bool isFalling = dayChangeNominal < 0;
    String changeSign = isFalling ? '-' : '+';
    Color subtitleColor = isFalling ? Colors.white : Colors.black;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lastPrice.currencyFormat(locale: 'ru', decimals: priceDecimals, symbol: '₽'),
                style: Get.textTheme.headlineSmall,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: isFalling ? redBrightColor : greenBrightColor,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(isFalling ? Icons.south_east_rounded : Icons.north_east_rounded, size: 15, color: subtitleColor),
                    const SizedBox(width: 10),
                    Text(
                      changeSign + dayChangeNominal.abs().currencyFormat(locale: 'ru', symbol: '₽') + ' (' + dayChangeNominal.abs().percentFormat() + ')',
                      style: TextStyle(color: subtitleColor, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Tooltip(
            showDuration: 5.seconds,
            triggerMode: TooltipTriggerMode.tap,
            message: getStockTooltipMessage(dayVolume: dayVolume, marketCapitalization: marketCapitalization),
            child: Icon(
              Icons.info_rounded,
              size: 28,
              color: ThemeBasedColor(context, Colors.black, Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  String getStockTooltipMessage({required num dayVolume, required num? marketCapitalization}) {
    /// Daily volume and market capitalization
    String info = 'volume24h'.tr + ': ' + dayVolume.compactFormat();
    if (marketCapitalization != null) info += '\n' + 'capitalization'.tr + ': ' + marketCapitalization.compactFormat();
    return info;
  }

  @override
  Widget build(BuildContext context) {
    switch (controller.asset.assetType) {
      case AssetType.stocks:
        StockModelWithMarketData mdStock = controller.mdAsset as StockModelWithMarketData;
        return getCommonMdRow(
          context,
          lastPrice: mdStock.lastPrice,
          dayChangeNominal: mdStock.dayChangeNominal,
          dayChangePercent: mdStock.dayChangePercent,
          priceDecimals: mdStock.priceDecimals,
          dayVolume: mdStock.dayVolume,
          marketCapitalization: mdStock.marketCapitalization,
        );

      default:
        throw UnimplementedError(); // TODO
    }
  }
}
