import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/model/asset/stock_model.dart';
import '../../../../utils/formatters.dart';
import '../../widgets/circle_avatar_placeholder.dart';

class MarketSection extends StatelessWidget {
  final String title;
  final Set<MarketSectionCardWithStocks>? stocks;
  final Set<MarketSectionCardWithCrypto>? crypto;

  const MarketSection({
    Key? key,
    required this.title,
    this.stocks,
    this.crypto,
  }) : super(key: key);

  int getItemCount() {
    if (stocks != null) {
      return stocks!.length;
    } else if (crypto != null) {
      return crypto!.length;
    } else {
      throw 'No assets provided';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            title,
            style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 335,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              if (stocks != null) {
                return MarketSectionCardWithStocks(
                  title: stocks!.elementAt(index).title,
                  stocks: stocks!.elementAt(index).stocks,
                );
              } else if (crypto != null) {
                return MarketSectionCardWithCrypto(title: title);
              } else {
                throw 'No assets provided';
              }
            },
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemCount: getItemCount(),
          ),
        )
      ],
    );
  }
}

class MarketSectionCard extends StatelessWidget {
  final String title;
  final Widget body;

  const MarketSectionCard({Key? key, required this.title, required this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.isPortrait ? context.width * 0.8 : context.width * 2 / 3,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: context.isDarkMode ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(title, style: context.textTheme.displaySmall?.copyWith(fontSize: 22)),
            ),
          ),
          body,
        ],
      ),
    );
  }
}

class MarketSectionCardWithStocks extends StatelessWidget {
  final String title;
  final List<StockModelWithMarketData> stocks;

  const MarketSectionCardWithStocks({Key? key, required this.title, required this.stocks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MarketSectionCard(
      title: title,
      body: Column(
          children: ListTile.divideTiles(
        context: context,
        tiles: stocks.map(
          (a) => ListTile(
            contentPadding: const EdgeInsets.all(0),
            minVerticalPadding: 0,
            minLeadingWidth: 35,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FittedBox(child: Text(a.displayName), fit: BoxFit.scaleDown),
                FittedBox(child: Text(a.subtitle, style: context.textTheme.bodyMedium), fit: BoxFit.scaleDown, alignment: Alignment.topLeft),
              ],
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ThirdLineSubtitle(asset: a),
                Text(
                  a.lastPrice.currencyFormat(locale: 'ru', symbol: '₽', decimals: a.priceDecimals),
                  style: context.textTheme.labelSmall?.copyWith(fontSize: 12),
                  maxLines: 1,
                ),
              ],
            ),
            leading: ClipOval(
              child: a.imageUrl == null
                  ? CircleAvatarPlaceholder(text: a.displayName[0])
                  : CachedNetworkImage(
                      width: 35,
                      height: 35,
                      imageUrl: a.imageUrl!,
                      progressIndicatorBuilder: (context, url, downloadProgress) => CircleAvatarPlaceholder(text: a.displayName[0]),
                      errorWidget: (context, url, error) => CircleAvatarPlaceholder(text: a.displayName[0]),
                    ),
            ),
            onTap: () {},
          ),
        ),
      ).toList()),
    );
  }
}

class MarketSectionCardWithCrypto extends StatelessWidget {
  final String title;

  const MarketSectionCardWithCrypto({Key? key, required this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class ThirdLineSubtitle extends StatelessWidget {
  final StockModelWithMarketData asset;
  const ThirdLineSubtitle({Key? key, required this.asset}) : super(key: key);

  bool get isFalling => asset.dayChangePercent < 0;

  Icon get icon => isFalling ? Icon(Icons.south_east_rounded, size: 15, color: iconColor) : Icon(Icons.north_east_rounded, size: 15, color: iconColor);
  Color get iconColor => isFalling ? Colors.red : Colors.green;

  num get todayAbsChange => asset.dayChangeNominal.abs().roundZeros();
  int get todayAbsChangeDecimals => todayAbsChange.countDecimals();

  String get changeNominal => todayAbsChange.currencyFormat(locale: 'ru', symbol: '₽', decimals: asset.priceDecimals);
  String get changePercent => ' · ' + (asset.dayChangePercent / 100).abs().percentFormat(decimals: 2);

  String get subtitle => changeNominal + changePercent;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          icon,
          const SizedBox(width: 3),
          Expanded(
            child: AutoSizeText(
              subtitle,
              style: context.textTheme.bodySmall,
              maxFontSize: context.textTheme.bodySmall!.fontSize!,
              minFontSize: 9,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
