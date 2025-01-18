abstract class Page<T> {
  List<T>? docs;
  int? total;
  int? page;
  int? pages;
  int? limit;
  String? sort;

  int get currentTotal => (page! - 1) * limit! + docs!.length;
}
