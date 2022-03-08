import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/history/history_controller.dart';

class HistoryPage extends GetView<HistoryPageController> {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Operations'),
    );
  }
}
