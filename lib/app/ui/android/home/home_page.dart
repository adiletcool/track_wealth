import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:track_wealth/app/ui/android/widgets/loading_widget.dart';

import '../../../controllers/home/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('oi'.tr),
      ),
      body: GetX<HomeController>(
        initState: (state) => Get.find<HomeController>().getAll(),
        builder: (controller) {
          return controller.postList.isEmpty
              ? const LoadingWidget()
              : ListView.builder(
                  itemBuilder: ((context, index) {
                    return ListTile(
                      title: Text(controller.postList[index].title ?? 'a'),
                      subtitle: Text(controller.postList[index].body ?? 'b'),
                      onTap: () {},
                    );
                  }),
                  itemCount: controller.postList.length,
                );
        },
      ),
    );
  }
}
