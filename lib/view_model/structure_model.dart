import 'dart:async';

import '/model/article.dart';
import '/provider/view_state_list_model.dart';
import '/provider/view_state_refresh_list_model.dart';
import '/service/wan_android_repository.dart';

import 'favourite_model.dart';

class StructureCategoryModel extends ViewStateListModel {
  @override
  Future<List?> loadData() async {
    return await (WanAndroidRepository.fetchTreeCategories() as FutureOr<List<dynamic>?>);
  }
}

class StructureListModel extends ViewStateRefreshListModel {
  final int? cid;

  StructureListModel(this.cid);

  @override
  Future<List?> loadData({int? pageNum}) async {
    return await (WanAndroidRepository.fetchArticles(pageNum, cid: cid) as FutureOr<List<dynamic>?>);
  }

  @override
  onCompleted(List data) {
    GlobalFavouriteStateModel.refresh(data as List<Article>);
  }
}

/// 网址导航
class NavigationSiteModel extends ViewStateListModel {
  @override
  Future<List?> loadData() async {
    return await (WanAndroidRepository.fetchNavigationSite() as FutureOr<List<dynamic>?>);
  }
}

