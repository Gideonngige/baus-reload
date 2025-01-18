import 'package:baustaka/api/blog_api.dart';
import 'package:baustaka/api/blog_like_api.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/blog.dart';
import 'package:baustaka/model/blog_page.dart';
import 'package:get/get.dart';

class BlogsController extends GetxController {
  var isFetching = false.obs;
  var showSearch = false.obs;

  BlogApi blogApi = Get.put(BlogApi());

  final _blogLikeApi = Get.put(BlogLikeApi());

  RxList<Blog> blogs = RxList.empty();

  BlogPage? _blogPage;

  String? q;

  Rx<String?> tag = Rx(null);

  @override
  void onInit() async {
    super.onInit();

    await fetch(true);
  }

  fetch(bool refresh) async {
    if (isFetching.isTrue) return;

    isFetching.value = true;

    if (refresh) {
      blogs.clear();

      _blogPage = null;
    } else if (_blogPage != null &&
        (_blogPage!.page! >= _blogPage!.pages! || _blogPage!.docs!.isEmpty)) {
      isFetching.value = false;
      return;
    }

    try {
      int page = _blogPage == null ? 1 : _blogPage!.page! + 1;

      Map<String, dynamic> query = {
        'page': page.toString(),
      };

      if (q != null && q!.trim().isNotEmpty) query.addAll({'q': q!.trim()});

      if (tag.value != null && tag.value != 'All') {
        query.addAll({'tag': tag.value.toString()});
      }

      _blogPage = (await blogApi.retrieve(query)).data!.blogPage;

      blogs.addAll(_blogPage!.docs!);
    } catch (e) {
      Util.toast(e);
    }
    isFetching.value = false;
  }

  blogLikeBlog(String blogId) async {
    try {
      int toggle =
          (await _blogLikeApi.toggle({'blogId': blogId})).data!.toggle!;

      for (var blog in blogs) {
        if (blogId == blog.id) {
          blog.blogLiked = toggle == 1;

          blog.blogLikes = blog.blogLikes! + toggle;
        }
      }

      blogs.refresh();
    } catch (e) {
      Util.toast(e);
    }
  }
}
