import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import '/provider/provider_widget.dart';
import '/ui/helper/favourite_helper.dart';
import '/model/article.dart';
import '/view_model/favourite_model.dart';
import '/view_model/user_model.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'article_detail_page.dart';

class ArticleDetailPluginPage extends StatefulWidget {
  final Article? article;
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  ArticleDetailPluginPage({this.article});

  @override
  _WebViewState createState() => _WebViewState(_controller);
}

class _WebViewState extends State<ArticleDetailPluginPage> {
  Completer<WebViewController> _finishedCompleter;
  _WebViewState(this._finishedCompleter);

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: widget.article!.link,
      javascriptMode: JavascriptMode.unrestricted,

    );
  }
}
