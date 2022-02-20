import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/model/asset/stock_model.dart';
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
            stocks: [
              MarketSectionCardWithStocks(
                title: 'finance'.tr,
                stocks: [
                  StockModelWithMarketData(
                    isin: 'RU0009029540',
                    primaryBoardId: 'TQBR',
                    secId: 'SBER',
                    shortName: 'Сбербанк',
                    name: 'Сбербанк России ПАО ао',
                    lastPrice: 260.83,
                    updateTime: '23:49:59',
                    lotSize: 10,
                    marketCapitalization: 5630523646840,
                    todayChangePercent: -5.22,
                    todayChangeNominal: -14.47,
                    priceDecimals: 2,
                  ),
                  StockModelWithMarketData(
                    isin: 'RU000A0JP5V6',
                    primaryBoardId: 'TQBR',
                    secId: 'VTBR',
                    shortName: 'ВТБ ао',
                    name: 'ао ПАО Банк ВТБ',
                    lastPrice: 0.040500,
                    updateTime: '23:49:59',
                    lotSize: 10000,
                    marketCapitalization: 524901924162,
                    todayChangePercent: -3.34,
                    todayChangeNominal: -0.0014,
                    priceDecimals: 6,
                  ),
                  StockModelWithMarketData(
                    isin: 'US87238U2033',
                    primaryBoardId: 'TQBR',
                    secId: 'TCSG',
                    shortName: 'TCS-гдр',
                    name: 'ГДР TCS Group Holding ORD SHS',
                    lastPrice: 5314.5,
                    updateTime: '23:49:59',
                    lotSize: 1,
                    todayChangePercent: -9.1,
                    todayChangeNominal: -520.1,
                    priceDecimals: 1,
                  ),
                  StockModelWithMarketData(
                    isin: 'RU0009100945',
                    primaryBoardId: 'TQBR',
                    secId: 'BSPB',
                    shortName: 'БСП ао',
                    name: 'ПАО "Банк "Санкт-Петербург" ао',
                    lastPrice: 83.89,
                    updateTime: '23:49:59',
                    lotSize: 10,
                    marketCapitalization: 39894244522,
                    todayChangePercent: -1.47,
                    todayChangeNominal: -11.49,
                    priceDecimals: 2,
                  ),
                ],
              ),
              MarketSectionCardWithStocks(
                title: 'energy'.tr,
                stocks: [
                  StockModelWithMarketData(
                    isin: 'RU0007288411',
                    primaryBoardId: 'TQBR',
                    secId: 'GMKN',
                    shortName: 'ГМКНорНик',
                    name: 'ГМК "Нор.Никель" ПАО ао',
                    lastPrice: 21688,
                    updateTime: '23:49:59',
                    lotSize: 1,
                    marketCapitalization: 3332461485312,
                    todayChangePercent: -3.41,
                    todayChangeNominal: -629,
                    priceDecimals: 0,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
