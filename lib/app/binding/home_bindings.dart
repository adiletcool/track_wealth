import 'package:get/get.dart';
import 'package:http/http.dart';

import '../controllers/home/home_controller.dart';
import '../data/provider/posts_api.dart';
import '../data/repository/posts_repository.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() {
      return HomeController(
        repository: MyRepository(
          apiClient: MyApiClient(httpClient: Client()),
        ),
      );
    });
  }
}
