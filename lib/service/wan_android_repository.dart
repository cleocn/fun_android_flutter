import 'package:dio/dio.dart';

import '/config/net/wan_android_api.dart';
import '/model/article.dart';
import '/model/banner.dart';
import '/model/coin_record.dart';
import '/model/search.dart';
import '/model/navigation_site.dart';
import '/model/tree.dart';
import '/model/user.dart';

class WanAndroidRepository {
  // 轮播
  static Future<List<Banner>?> fetchBanners() async {
    Response<dynamic> response = await http.get('banner/json');
    return response.data
        .map<Banner>((item) => Banner.fromJsonMap(item))
        .toList();
  }

  // 置顶文章
  static Future<List<Article>?> fetchTopArticles() async {
    Response<dynamic> response = await http.get('article/top/json');
    return response.data.map<Article>((item) => Article.fromMap(item)).toList();
  }

  // 文章
  static Future<List<Article>?> fetchArticles(int? pageNum, {int? cid}) async {
    await Future.delayed(Duration(seconds: 1)); //增加动效
    Response<dynamic> response = await http.get('article/list/$pageNum/json',
        queryParameters: (cid != null ? {'cid': cid} : null));
    return response.data['datas']
        .map<Article>((item) => Article.fromMap(item))
        .toList();
  }

  // 项目分类
  static Future<List<Tree>?> fetchTreeCategories() async {
    Response<dynamic> response = await http.get('tree/json');
    return response.data.map<Tree>((item) => Tree.fromJsonMap(item)).toList();
  }

  // 体系分类
  static Future<List<Tree>?> fetchProjectCategories() async {
    Response<dynamic> response = await http.get('project/tree/json');
    return response.data.map<Tree>((item) => Tree.fromJsonMap(item)).toList();
  }

  // 导航
  static Future<List<NavigationSite>?> fetchNavigationSite() async {
    Response<dynamic> response = await http.get('navi/json');
    return response.data
        .map<NavigationSite>((item) => NavigationSite.fromMap(item))
        .toList();
  }

  // 公众号分类
  static Future<List<Tree>?> fetchWechatAccounts() async {
    Response<dynamic> response = await http.get('wxarticle/chapters/json');
    return response.data.map<Tree>((item) => Tree.fromJsonMap(item)).toList();
  }

  // 公众号文章
  static Future<List<Article>?> fetchWechatAccountArticles(int? pageNum, int? id) async {
    Response<dynamic> response = await http.get('wxarticle/list/$id/$pageNum/json');
    return response.data['datas']
        .map<Article>((item) => Article.fromMap(item))
        .toList();
  }

  // 搜索热门记录
  static Future<List<SearchHotKey>?> fetchSearchHotKey() async {
    Response<dynamic> response = await http.get('hotkey/json');
    return response.data
        .map<SearchHotKey>((item) => SearchHotKey.fromMap(item))
        .toList();
  }

  // 搜索结果
  static Future<List<Article>?> fetchSearchResult({key = "", int? pageNum = 0}) async {
    Response<Map<dynamic, dynamic>> response =
        await http.post<Map>('article/query/$pageNum/json', queryParameters: {
      'k': key,
    });
    return response.data!['datas']
        .map<Article>((item) => Article.fromMap(item))
        .toList();
  }

  /// 登录
  /// [Http._init] 添加了拦截器 设置了自动cookie.
  static Future<User> login(String? username, String? password) async {
    Response<Map<dynamic, dynamic>> response = await http.post<Map>('user/login', queryParameters: {
      'username': username,
      'password': password,
    });
    return User.fromJsonMap(response.data as Map<String, dynamic>);
  }

  /// 注册
  static Future register(
      String? username, String? password, String? rePassword) async {
    Response<Map<dynamic, dynamic>> response = await http.post<Map>('user/register', queryParameters: {
      'username': username,
      'password': password,
      'repassword': rePassword,
    });
    return User.fromJsonMap(response.data as Map<String, dynamic>);
  }

  /// 登出
  static logout() async {
    /// 自动移除cookie
    await http.get('user/logout/json');
  }

  static testLoginState() async {
    await http.get('lg/todo/listnotdo/0/json/1');
  }

  // 收藏列表
  static Future<List<Article>?> fetchCollectList(int? pageNum) async {
    Response<Map<dynamic, dynamic>> response = await http.get<Map>('lg/collect/list/$pageNum/json');
    return response.data!['datas']
        .map<Article>((item) => Article.fromMap(item))
        .toList();
  }

  // 收藏
  static collect(id) async {
    await http.post('lg/collect/$id/json');
  }

  // 取消收藏
  static unCollect(id) async {
    await http.post('lg/uncollect_originId/$id/json');
  }

  // 取消收藏2
  static unMyCollect({id, originId}) async {
    await http.post('lg/uncollect/$id/json',
        queryParameters: {'originId': originId ?? -1});
  }

  // 个人积分
  static Future fetchCoin() async {
    Response<dynamic> response = await http.get('lg/coin/getcount/json');
    return response.data;
  }

  // 我的积分记录
  static Future<List<CoinRecord>?> fetchCoinRecordList(int? pageNum) async {
    Response<dynamic> response = await http.get('lg/coin/list/$pageNum/json');
    return response.data['datas']
        .map<CoinRecord>((item) => CoinRecord.fromMap(item))
        .toList();
  }

  // 积分排行榜
  /// {
  ///        "coinCount": 448,
  ///        "username": "S**24n"
  ///      },
  static Future fetchRankingList(int? pageNum) async {
    Response<dynamic> response = await http.get('coin/rank/$pageNum/json');
    return response.data['datas'];
  }
}
