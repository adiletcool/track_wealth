import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/model/asset/asset_model.dart';
import '../../../theme/app_color.dart';

class AssetPageAppBar extends StatelessWidget {
  final AssetModel asset;

  const AssetPageAppBar(this.asset, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonColor = ThemeBasedColor(context, Colors.black, Colors.white);

    return SliverAppBar(
      elevation: 0,
      pinned: true,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_rounded,
          color: buttonColor,
        ),
        onPressed: Get.back,
      ),
      title: ListTile(
        contentPadding: const EdgeInsets.all(0),
        title: Text(
          asset.displayName,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(asset.subtitle),
      ),
      centerTitle: false,
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      actions: [
        Container(
          padding: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), topLeft: Radius.circular(30)),
            color: Colors.indigo.withOpacity(.3),
          ),
          child: IconButton(
            icon: Icon(Icons.star_border_rounded, color: buttonColor, size: 28),
            onPressed: () {}, // TODO: make asset starred
          ),
        )
      ],
    );
  }
}
