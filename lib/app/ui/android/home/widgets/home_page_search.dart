import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../../../controllers/home/asset_search_controller.dart';
import '../../../../data/enums/market_types.dart';
import '../../../../data/model/asset/asset_model.dart';
import '../../widgets/circle_avatar_placeholder.dart';
import 'home_page_search_empty_result.dart';
import 'home_page_search_preset.dart';
import 'market_type_filter.dart';

class AssetSearchDelegate extends SearchDelegate<AssetModel> {
  final AssetSearchController assetSearchController = Get.find<AssetSearchController>();

  AssetSearchDelegate() : super(searchFieldLabel: 'search'.tr);

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return theme.copyWith(
      appBarTheme: context.theme.appBarTheme.copyWith(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: searchFieldStyle ?? theme.inputDecorationTheme.hintStyle,
        border: InputBorder.none,
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      AnimatedCrossFade(
        firstChild: Container(),
        secondChild: Center(
          child: IconButton(
            icon: Icon(Icons.clear_rounded, color: context.theme.iconTheme.color),
            onPressed: () {
              query = '';
              assetSearchController.clearSearchQuery();
            },
          ),
        ),
        crossFadeState: query.isEmpty ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        duration: 200.milliseconds,
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_rounded, color: context.theme.iconTheme.color),
      onPressed: Get.back,
    );
  }

  @override
  Widget buildResults(BuildContext context) => buildSuggestions(context);

  @override
  Widget buildSuggestions(BuildContext context) {
    assetSearchController.updateSearchQuery(query);
    return AssetSearchSuggestionBody(query: query);
  }
}

class AssetSearchSuggestionBody extends GetView<AssetSearchController> {
  final String query;
  const AssetSearchSuggestionBody({Key? key, required this.query}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => FutureBuilder(
          future: controller.getSearchSuggestion(controller.searchQuery.value),
          builder: (context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData) {
              if (query.isNotEmpty) {
                return Obx(() => Column(
                      children: [
                        const MarketTypeFiltersRow(),
                        controller.filteredSuggestedAssets.isEmpty
                            ? const EmptySearchResult()
                            : Expanded(
                                child: GroupedListView<AssetModel, AssetType>(
                                  sort: false,
                                  padding: const EdgeInsets.only(top: 15),
                                  elements: controller.filteredSuggestedAssets.toList(),
                                  groupBy: (AssetModel asset) => asset.assetType,
                                  groupSeparatorBuilder: (AssetType groupByValue) => AssetSearchGroup(groupName: groupByValue.name),
                                  itemBuilder: (context, AssetModel asset) => AssetSearchItem(asset: asset),
                                ),
                              ),
                      ],
                    ));
              }
              return const AssetSearchPreset();
            }
            return Container();
          },
        ));
  }
}

class AssetSearchItem extends StatelessWidget {
  final AssetModel asset;
  const AssetSearchItem({Key? key, required this.asset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(asset.displayName),
      subtitle: Text(
        asset.subtitle,
        maxLines: 2,
        overflow: TextOverflow.fade,
      ),
      leading: ClipOval(
        child: CachedNetworkImage(
          width: 35,
          height: 35,
          imageUrl: asset.imageUrl ?? '',
          progressIndicatorBuilder: (context, url, downloadProgress) => CircleAvatarPlaceholder(text: asset.displayName[0]),
          errorWidget: (context, url, error) => CircleAvatarPlaceholder(text: asset.displayName[0]),
        ),
      ),
      onTap: () {
        // switch (asset.assetType) {
        //   case AssetType.stocks:
        //     SearchStockModel stock = asset as SearchStockModel;
        //     throw UnimplementedError();
        //   case AssetType.crypto:
        //     SearchCoinmarketcapModel crypto = asset as SearchCoinmarketcapModel;
        //     throw UnimplementedError();
        //   case AssetType.currencies:
        //     SearchCurrencyModel currency = asset as SearchCurrencyModel;
        //     throw UnimplementedError();
        //   case AssetType.bonds:
        //     SearchBondModel bond = asset as SearchBondModel;
        //     throw UnimplementedError();
        // }
      },
    );
  }
}

class AssetSearchGroup extends GetView<AssetSearchController> {
  final String groupName;
  const AssetSearchGroup({Key? key, required this.groupName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.selectedMarketType.value == MarketType.all
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(groupName.tr, style: const TextStyle(fontSize: 18)),
          )
        : Container());
  }
}
