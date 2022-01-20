import 'article.dart';

class NavigationSite {

  List<Article>? articles;
  int? cid;
  String? name;

  static NavigationSite fromMap(Map<String, dynamic> map) {
    NavigationSite naviBean = NavigationSite();
    naviBean.articles = List.generate((map['articles'] as List? ?? []).length, (index) => Article.fromMap((map['articles'] as List? ?? [])[index]));
      // ..addAll((map['articles'] as List? ?? []).map((o) => Article.fromMap(o)));
    naviBean.cid = map['cid'];
    naviBean.name = map['name'];
    return naviBean;
  }

  Map toJson() => {
        "articles": articles,
        "cid": cid,
        "name": name,
      };
}
