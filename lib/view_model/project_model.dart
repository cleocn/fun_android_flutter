import 'dart:async';

import '/model/article.dart';
import '/model/tree.dart';
import '/provider/view_state_refresh_list_model.dart';
import '/provider/view_state_list_model.dart';
import '/service/wan_android_repository.dart';

import 'favourite_model.dart';

class ProjectCategoryModel extends ViewStateListModel<Tree> {
  @override
  Future<List<Tree>?> loadData() async {
    return await (WanAndroidRepository.fetchProjectCategories() as Future<List<Tree>?>);
  }
}

class ProjectListModel extends ViewStateRefreshListModel<Article> {
  @override
  Future<List<Article>?> loadData({int? pageNum}) async {
    return await (WanAndroidRepository.fetchArticles(pageNum, cid: 294) as Future<List<Article>?>);
  }
  @override
  onCompleted(List data) {
    GlobalFavouriteStateModel.refresh(data as List<Article>);
  }
}
