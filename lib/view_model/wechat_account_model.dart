import 'dart:async';

import '/model/article.dart';
import '/model/tree.dart';
import '/provider/view_state_refresh_list_model.dart';
import '/provider/view_state_list_model.dart';
import '/service/wan_android_repository.dart';

import 'favourite_model.dart';

/// 微信公众号
class WechatAccountCategoryModel extends ViewStateListModel<Tree> {
  @override
  Future<List<Tree>?> loadData() async {
    return await (WanAndroidRepository.fetchWechatAccounts() as FutureOr<List<Tree>?>);
  }
}

/// 微信公众号文章
class WechatArticleListModel extends ViewStateRefreshListModel<Article> {
  /// 公众号id
  final int? id;

  WechatArticleListModel(this.id);

  @override
  Future<List<Article>?> loadData({int? pageNum}) async {
    return await (WanAndroidRepository.fetchWechatAccountArticles(pageNum, id) as FutureOr<List<Article>?>);
  }

  @override
  onCompleted(List data) {
    GlobalFavouriteStateModel.refresh(data as List<Article>);
  }
}
