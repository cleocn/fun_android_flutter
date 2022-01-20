import 'package:flutter/material.dart'
    hide SliverAnimatedListState, SliverAnimatedList;
// import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '/flutter/refresh_animatedlist.dart';
import '/generated/l10n.dart';
import '/ui/helper/refresh_helper.dart';
import '/ui/widget/article_skeleton.dart';
import '/ui/widget/skeleton.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '/config/router_manger.dart';
import '/model/article.dart';
import '/provider/provider_widget.dart';
import '/ui/widget/article_list_Item.dart';
import '/provider/view_state_widget.dart';
import '/view_model/favourite_model.dart';
import '/view_model/login_model.dart';

/// 必须为StatefulWidget,才能根据[GlobalKey]取出[currentState].
/// 否则从详情页返回后,无法移除没有收藏的item
class FavouriteListPage extends StatefulWidget {
  @override
  _FavouriteListPageState createState() => _FavouriteListPageState();
}

class _FavouriteListPageState extends State<FavouriteListPage> {
  final GlobalKey<SliverAnimatedListState> listKey =
      GlobalKey<SliverAnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context)!.myFavourites),
      ),
      body: ProviderWidget<FavouriteListModel>(
        model: FavouriteListModel(loginModel: LoginModel(Provider.of(context))),
        onModelReady: (model) async {
          await model.initData();
        },
        builder: (context, FavouriteListModel model, child) {
          if (model.isBusy) {
            return SkeletonList(
              builder: (context, index) => ArticleSkeletonItem(),
            );
          } else if (model.isEmpty) {
            return ViewStateEmptyWidget(onPressed: model.initData);
          } else if (model.isError) {
            if (model.viewStateError!.isUnauthorized) {
              return ViewStateUnAuthWidget(onPressed: () async {
                var success =
                    await Navigator.of(context).pushNamed(RouteName.login);
                // 登录成功,获取数据,刷新页面
                if (success as bool? ?? false) {
                  model.initData();
                }
              });
            } else if (model.list!.isEmpty) {
              // 只有在页面上没有数据的时候才显示错误widget
              return ViewStateErrorWidget(
                  error: model.viewStateError, onPressed: model.initData);
            }
          }
          return SmartRefresher(
              controller: model.refreshController,
              header: WaterDropHeader(),
              footer: RefresherFooter(),
              onRefresh: () async {
                await model.refresh();
                listKey.currentState!.refresh(model.list!.length);
              },
              onLoading: () async {
                await model.loadMore();
                listKey.currentState!.refresh(model.list!.length);
              },
              enablePullUp: true,
              child: CustomScrollView(slivers: <Widget>[
                SliverAnimatedList(
                    key: listKey,
                    initialItemCount: model.list!.length,
                    itemBuilder: (context, index, animation) {
                      Article item = model.list![index];
                      return Slidable(
                        // The end action pane is the one at the right or the bottom side.
                        endActionPane: ActionPane(
                          motion: ScrollMotion(),
                          children: [
                             SlidableAction(
                              // An action can be bigger than the others.
                              flex: 2,
                              onPressed: (_) {
                                FavouriteModel(globalFavouriteModel: Provider.of(context, listen: false))
                                    .collect(item);
                                removeItem(model.list!, index);
                              },
                              // backgroundColor: Color(0xFF7BC043),
                              foregroundColor: Colors.redAccent,
                              icon: Icons.delete,
                              label: S.of(context)!.collectionRemove,
                            ),
                          ],
                        ),
                        child: SizeTransition(
                            axis: Axis.vertical,
                            sizeFactor: animation,
                            child: ArticleItemWidget(
                              item,
                              hideFavourite: true,
                              onTap: () async {
                                await Navigator.of(context).pushNamed(
                                    RouteName.articleDetail,
                                    arguments: item);
                                if (!(item.collect ?? true)) {
                                  removeItem(model.list!, index);
                                }
                              },
                            )),
                      );
                    })
              ]));
        },
      ),
    );
  }

  /// 移除取消收藏的item
  removeItem(List list, int index) {
    var removeItem = list.removeAt(index);
    listKey.currentState!.removeItem(
        index,
        (context, animation) => SizeTransition(
            axis: Axis.vertical,
            axisAlignment: 1.0,
            sizeFactor: animation,
            child: ArticleItemWidget(
              removeItem,
              hideFavourite: true,
            )));
  }
}
