import 'package:baustaka/api/post_api.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/post.dart';
import 'package:baustaka/model/post_page.dart';
import 'package:get/get.dart';

class PostsController extends GetxController {
  var isFetching = false.obs;
  var showSearch = false.obs;

  PostApi postApi = Get.put(PostApi());

  RxList<Post> posts = RxList.empty();

  PostPage? _postPage;

  String? q;

  final String? withProduct;

  PostsController({required this.withProduct});

  @override
  void onInit() async {
    super.onInit();

    await fetch(true);
  }

  fetch(bool refresh) async {
    if (isFetching.isTrue) return;

    isFetching.value = true;

    if (refresh) {
      posts.clear();

      _postPage = null;
    } else if (_postPage != null &&
        (_postPage!.page! >= _postPage!.pages! || _postPage!.docs!.isEmpty)) {
      isFetching.value = false;
      return;
    }

    try {
      int page = _postPage == null ? 1 : _postPage!.page! + 1;

      Map<String, dynamic> query = {
        'page': page.toString(),
      };

      if (withProduct != null) {
        query.addAll({'withProduct': withProduct});
      }

      if (q != null && q!.trim().isNotEmpty) query.addAll({'q': q!.trim()});

      _postPage = (await postApi.retrieve(query)).data!.postPage;

      posts.addAll(_postPage!.docs!);
    } catch (e) {
      Util.toast(e);
    }
    isFetching.value = false;
  }
}
