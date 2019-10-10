import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan_wyy/bean/user_info.dart';
import 'package:flutter_wan_wyy/models/profile.dart';
import 'package:flutter_wan_wyy/models/user.dart';

import 'global.dart';


class ProfileChangeNotifier extends ChangeNotifier {
  Profile get _profile => Global.profile;

  @override
  void notifyListeners() {
    Global.saveProfile(); //保存Profile变更
    super.notifyListeners(); //通知依赖的Widget更新
  }
}
//用户状态
class UserModel extends ProfileChangeNotifier {
  User get user => _profile.user;

  // APP是否登录(如果有用户信息，则证明登录过)
  bool get isLogin => (user != null && SpUtil.getString(BaseConstant.keyAppToken) != null && _profile.isLogin);

  //用户信息发生变化，更新用户信息并通知依赖它的子孙Widgets更新
  set user(User user) {
    if (user?.nickname != _profile.user?.nickname) {
      _profile.lastLogin = user.nickname;
      _profile.user = user;
      notifyListeners();
    }
  }

  void outLogin() {
    SpUtil.remove(BaseConstant.keyAppToken);
    _profile.isLogin = false;
    notifyListeners();
  }
}
//主题状态
class ThemeModel extends ProfileChangeNotifier {
  // 获取当前主题，如果没设置主题，则默认使用蓝色主题
  ColorSwatch get theme => Global.themes
      .firstWhere((e) => e.value == _profile.theme, orElse: () => Colors.blue);

  // 主题改变后，通知其依赖项，新主题会立即生效
  set theme(ColorSwatch color) {
    if (color != theme) {
      _profile.theme = color[500].value;
      notifyListeners();
    }
  }
}
//App语言状态
class LocaleModel extends ProfileChangeNotifier {
  // 获取当前用户的APP语言配置Locale类，如果为null，则语言跟随系统语言
  Locale getLocale() {
    if (_profile.locale == null) return null;
    var t = _profile.locale.split("_");
    return Locale(t[0], t[1]);
  }

  // 获取当前Locale的字符串表示
  String get locale => _profile.locale;

  // 用户改变APP语言后，通知依赖项更新，新语言会立即生效
  set locale(String locale) {
    if (locale != _profile.locale) {
      _profile.locale = locale;
      notifyListeners();
    }
  }
}