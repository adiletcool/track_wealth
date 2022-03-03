import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/operations/operations_controller.dart';

class OperationsPage extends GetView<OperationsController> {
  const OperationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Operations'),
    );
  }
}
