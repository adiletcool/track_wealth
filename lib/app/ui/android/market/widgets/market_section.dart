import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:track_wealth/app/utils/formatters.dart';

import '../../../../data/model/asset/asset_model.dart';

class MarketSection extends StatelessWidget {
  final String title;
  final List<MarketSectionCard> cards;

  const MarketSection({
    Key? key,
    required this.title,
    required this.cards,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 350,
          child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => MarketSectionCard(
                    title: cards[index].title,
                    assets: cards[index].assets,
                  ),
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemCount: cards.length),
        )
      ],
    );
  }
}

class MarketSectionCard extends StatelessWidget {
  final String title;
  final List<SearchAssetModel> assets;

  const MarketSectionCard({
    Key? key,
    required this.title,
    required this.assets,
  }) : super(key: key);

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
            child: Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(height: 10),
          Column(
              children: ListTile.divideTiles(
                  context: context,
                  tiles: assets.map((a) => ListTile(
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
                          child: CachedNetworkImage(
                            width: 35,
                            height: 35,
                            imageUrl: a.imageUrl,
                            progressIndicatorBuilder: (context, url, downloadProgress) => CircleAvatarPlaceholder(text: a.displayName[0]),
                            errorWidget: (context, url, error) => CircleAvatarPlaceholder(text: a.displayName[0]),
                          ),
                        ),
                        onTap: () {},
                      ))).toList()),
        ],
      ),
    );
  }
}

class ThirdLineSubtitle extends StatelessWidget {
  final SearchAssetModel asset;
  const ThirdLineSubtitle({Key? key, required this.asset}) : super(key: key);

  bool get isFalling => asset.todayChangePercent < 0;

  Icon get icon => isFalling ? Icon(Icons.south_east_rounded, size: 15, color: iconColor) : Icon(Icons.north_east_rounded, size: 15, color: iconColor);
  Color get iconColor => isFalling ? Colors.red : Colors.green;

  num get todayAbsChange => asset.todayChangeNominal.abs().roundZeros();
  int get todayAbsChangeDecimals => todayAbsChange.countDecimals();

  String get changeNominal => todayAbsChange.currencyFormat(locale: 'ru', symbol: '₽', decimals: asset.priceDecimals);
  String get changePercent => ' · ' + (asset.todayChangePercent / 100).abs().percentFormat(decimals: 2);

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

class CircleAvatarPlaceholder extends StatelessWidget {
  final String text;

  CircleAvatarPlaceholder({Key? key, required this.text}) : super(key: key);

  final List<Color> randomColors = [Colors.indigo, Colors.indigoAccent, Colors.teal];

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: randomColors[Random().nextInt(randomColors.length)],
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
