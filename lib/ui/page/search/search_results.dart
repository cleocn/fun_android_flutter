import 'package:flutter/material.dart';
import '/ui/helper/refresh_helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '/model/article.dart';
import '/provider/provider_widget.dart';
import '/ui/widget/article_list_Item.dart';
import '/provider/view_state_widget.dart';
import '/view_model/search_model.dart';

class SearchResults extends StatelessWidget {
  final String? keyword;
  final SearchHistoryModel? searchHistoryModel;

  SearchResults({this.keyword, this.searchHistoryModel});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<SearchResultModel>(
      model: SearchResultModel(
          keyword: keyword, searchHistoryModel: searchHistoryModel),
      onModelReady: (model) {
        model.initData();
      },
      builder: (context, model, child) {
        if (model.isBusy) {
          return ViewStateBusyWidget();
        } else if (model.isError && model.list!.isEmpty) {
          return ViewStateErrorWidget(
              error: model.viewStateError, onPressed: model.initData);
        } else if (model.isEmpty) {
          return ViewStateEmptyWidget(onPressed: model.initData);
        }
        return SmartRefresher(
            controller: model.refreshController,
            header: WaterDropHeader(),
            footer: RefresherFooter(),
            onRefresh: model.refresh,
            onLoading: model.loadMore,
            enablePullUp: true,
            child: ListView.builder(
                itemCount: model.list!.length,
                itemBuilder: (context, index) {
                  Article item = model.list![index];
                  return ArticleItemWidget(item);
                }));
      },
    );
  }
}
