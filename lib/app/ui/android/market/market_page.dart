import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/market/market_controller.dart';
import '../../../data/model/asset/stock_model.dart';
import 'widgets/header.dart';
import 'widgets/market_section.dart';

class MarketPage extends StatelessWidget {
  MarketPage({Key? key}) : super(key: key);
  final ScrollController scrollController = ScrollController();
  final MarketController authController = Get.put(MarketController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: CustomScrollView(
          controller: scrollController,
          slivers: const <Widget>[
            MarketPageHeader(),
            MarketPageBody(),
          ],
        ),
      ),
    );
  }
}

class MarketPageBody extends StatelessWidget {
  const MarketPageBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(8.0),
      sliver: SliverFillRemaining(
        hasScrollBody: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: loadSections(),
        ),
      ),
    );
  }

  List<MarketSection> loadSections() {
    return [
      popularSection,
    ];
  }
}

// TODO: load preset of assets:
// ! banking sector: SBER, TCSG, VTBR, BSPB
final MarketSection popularSection = MarketSection(
  title: 'russian stock market'.tr,
  cards: [
    MarketSectionCard(
      title: 'banking sector'.tr,
      assets: [
        SearchStockModel(
          isin: 'RU0009029540',
          boardId: 'TQBR',
          secId: 'SBER',
          shortName: 'Сбербанк',
          longName: 'Сбербанк России ПАО ао',
          lastPrice: 260.83,
          updateTime: '23:49:59',
          lotSize: 10,
          marketCapitalization: 5630523646840,
          todayChangePercent: -5.22,
          todayChangeNominal: -14.47,
          priceDecimals: 2,
        ),
        SearchStockModel(
          isin: 'RU000A0JP5V6',
          boardId: 'TQBR',
          secId: 'VTBR',
          shortName: 'ВТБ ао',
          longName: 'ао ПАО Банк ВТБ',
          lastPrice: 0.040500,
          updateTime: '23:49:59',
          lotSize: 10000,
          marketCapitalization: 524901924162,
          todayChangePercent: -3.34,
          todayChangeNominal: -0.0014,
          priceDecimals: 6,
        ),
        SearchStockModel(
          isin: 'US87238U2033',
          boardId: 'TQBR',
          secId: 'TCSG',
          shortName: 'TCS-гдр',
          longName: 'ГДР TCS Group Holding ORD SHS',
          lastPrice: 5314.5,
          updateTime: '23:49:59',
          lotSize: 1,
          todayChangePercent: -9.1,
          todayChangeNominal: -520.1,
          priceDecimals: 1,
        ),
        SearchStockModel(
          isin: 'RU0009100945',
          boardId: 'TQBR',
          secId: 'BSPB',
          shortName: 'БСП ао',
          longName: 'ПАО "Банк "Санкт-Петербург" ао',
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
    MarketSectionCard(
      title: 'energy sector'.tr,
      assets: [
        SearchStockModel(
          isin: 'RU0007288411',
          boardId: 'TQBR',
          secId: 'GMKN',
          shortName: 'ГМКНорНик',
          longName: 'ГМК "Нор.Никель" ПАО ао',
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
);
