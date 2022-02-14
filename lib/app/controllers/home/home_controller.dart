import 'package:get/get.dart';
import 'package:track_wealth/app/data/model/post_model.dart';
import 'package:track_wealth/app/data/repository/posts_repository.dart';

class HomeController extends GetxController {
  final MyRepository repository;

  HomeController({required this.repository});

  final RxList<PostModel> _postsList = <PostModel>[].obs;

  List<PostModel> get postList => _postsList;
  set postList(value) => _postsList.value = value;

  final Rx<PostModel> _post = PostModel().obs;
  get post => _post.value;
  set post(value) => _post.value = value;

  getAll() {
    repository.getAll().then((data) => postList = data);
  }
}
