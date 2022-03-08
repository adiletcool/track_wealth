import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OperationPageAppBar extends StatelessWidget {
  final String displayName;
  const OperationPageAppBar(this.displayName, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      title: Text(displayName),
    );
  }
}
