import 'dart:async';

import '/model/coin_record.dart';
import '/provider/view_state_model.dart';
import '/provider/view_state_refresh_list_model.dart';
import '/service/wan_android_repository.dart';

/// 个人积分
class CoinModel extends ViewStateModel {
  int? coin = 0;

  initData() async {
    setBusy();
    try {
      coin = await (WanAndroidRepository.fetchCoin() as FutureOr<int?>);
      setIdle();
    } catch (e, s) {
      setError(e,s);
    }
  }
}

/// 个人积分
class CoinRecordListModel extends ViewStateRefreshListModel<CoinRecord> {
  @override
  Future<List<CoinRecord>?> loadData({int? pageNum}) async {
    return await (WanAndroidRepository.fetchCoinRecordList(pageNum) as FutureOr<List<CoinRecord>?>);
  }
}

/// 积分排行榜
class CoinRankingListModel extends ViewStateRefreshListModel {
  @override
  Future<List?> loadData({int? pageNum}) async {
    return await (WanAndroidRepository.fetchRankingList(pageNum) as FutureOr<List<dynamic>?>);
  }
}
