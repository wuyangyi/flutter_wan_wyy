import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan_wyy/utils/utils.dart';
import 'package:flutter_wan_wyy/widgets/web_scaffold.dart';
import 'package:url_launcher/url_launcher.dart';
class NavigatorUtil {

  ///打开webview
  static void pushWeb(BuildContext context,
      {String title, String titleId, String url}) {
    if (context == null || ObjectUtil.isEmpty(url)) return;
    if (url.endsWith(".apk")) {
      launchInBrowser(url, title: title ?? titleId);
    } else {
      Navigator.push(
          context,
          new CupertinoPageRoute<void>(
              builder: (ctx) => new WebScaffold(
                title: title,
                titleId: titleId,
                url: url,
              )));
    }
  }

  ///打开page
  static Future<T> pushPage<T extends Object>(BuildContext context, String routeName, {bool needLogin = false, bool isNeedCloseRoute = false}) {
    if(context == null || routeName == null) return null;
    if (needLogin && !Util.isLogin(context)) {
      return pushPage(context, "login");
    }
    if (isNeedCloseRoute) {
      return Navigator.of(context).pushReplacementNamed(routeName);
    }
    return Navigator.of(context).pushNamed(routeName);
  }

  static Future<Null> launchInBrowser(String url, {String title}) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }

}