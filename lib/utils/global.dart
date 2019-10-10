import 'dart:convert';

import 'package:flustars/flustars.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan_wyy/bean/user_info.dart';
import 'package:flutter_wan_wyy/models/profile.dart';
import 'package:flutter_wan_wyy/net/newwork.dart';
import 'package:flutter_wan_wyy/res/index.dart';
import 'package:shared_preferences/shared_preferences.dart';


//提供五种可选择的主题色
const themeColors = <Color>[
  Colors.blue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.red,
  Colors.pink,
  Colors.purple,
  Colors.deepPurple,
  Colors.indigo,
  Colors.orange,
  Colors.yellow,
  Colors.brown,
];

class Global {
  static SharedPreferences _prefs;
  static Profile profile = Profile();

  //可选择主题列表
  static List<Color> get themes => themeColors;
//
//  //是否为release版
//  static bool get isRelease => bool.fromEnvironment("dart.vm.product");

  //初始化全局信息，会在app启动时执行
  static Future init() async {
    await SpUtil.getInstance();
    _prefs = await SharedPreferences.getInstance();
    var _profile = _prefs.getString(Ids.appProfile);
    if (_profile != null) {
      try {
        profile = Profile.fromJson(jsonDecode(_profile));
      } catch (e) {
        print(e);
      }
    }

  }
  // 持久化Profile信息
  static saveProfile() =>
      _prefs.setString(Ids.appProfile, jsonEncode(profile.toJson()));

}

//多语言
//Locale资源类
class GmLocalizations {
  GmLocalizations(this.languageCode);
  //语言类别
  String languageCode = "zh";
  //为了使用方便，我们定义一个静态方法
  static GmLocalizations of(BuildContext context) {
    return Localizations.of<GmLocalizations>(context, GmLocalizations);
  }

  String textById(String id) {
    return localizedSimpleValues[languageCode][id];
  }

  String get appName {
    if (languageCode == "en") {
      return "Boutique Reading";
    }
    return "精品阅读";
  }

  String get jump {
    if (languageCode == "en") {
      return "jump";
    }
    return "跳过";
  }

  String get cancel {
    if (languageCode == "en") {
      return "cancel";
    }
    return "取消";
  }

  //确定
  String get sure {
    if (languageCode == "en") {
      return "sure";
    }
    return "确定";
  }

  String get login {
    if (languageCode == "en") {
      return "login";
    }
    return "登录";
  }

  String get logging {
    if (languageCode == "en") {
      return "Logging in...";
    }
    return "正在登录...";
  }

  String get registering {
    if (languageCode == "en") {
      return "Registering...";
    }
    return "正在注册...";
  }

  String get loginFail {
    if (languageCode == "en") {
      return "Login failed";
    }
    return "登录失败";
  }

  String get loginSuccess {
    if (languageCode == "en") {
      return "login successful";
    }
    return "登录成功";
  }

  String get register {
    if (languageCode == "en") {
      return "register";
    }
    return "注册";
  }

  String get input_phone {
    if (languageCode == "en") {
      return "please enter user name";
    }
    return "请输入用户名";
  }

  String get input_sex_phone {
    if (languageCode == "en") {
      return "User name is at least 6 digits~";
    }
    return "用户名至少6位~";
  }

  String get input_pwd {
    if (languageCode == "en") {
      return "Please enter your password";
    }
    return "请输入密码";
  }

  String get input_sure_pwd {
    if (languageCode == "en") {
      return "Please confirm your password";
    }
    return "请确认密码";
  }


  String get input_sex_pwd {
    if (languageCode == "en") {
      return "Password at least 6 digits~";
    }
    return "密码至少6位~";
  }

  String get input_sure_pwd_diff {
    if (languageCode == "en") {
      return "Confirm password is not the same as password";
    }
    return "确认密码与密码不相同";
  }

  String get new_user {
    if (languageCode == "en") {
      return "new user?";
    }
    return "新用户？";
  }

  String get homePage {
    if (languageCode == "en") {
      return "Home";
    }
    return "主页";
  }

  String get project {
    if (languageCode == "en") {
      return "Project";
    }
    return "项目";
  }

  String get event {
    if (languageCode == "en") {
      return "Events";
    }
    return "动态";
  }

  String get system {
    if (languageCode == "en") {
      return "System";
    }
    return "体系";
  }

  //设置
  String get setting {
    if (languageCode == "en") {
      return "Setting";
    }
    return "设置";
  }

  //收藏
  String get collect {
    if (languageCode == "en") {
      return "Collect";
    }
    return "收藏";
  }

  //关于
  String get about {
    if (languageCode == "en") {
      return "About";
    }
    return "关于";
  }

  //主题
  String get theme {
    if (languageCode == "en") {
      return "Theme";
    }
    return "主题";
  }
  //语言
  String get language {
    if (languageCode == "en") {
      return "Language";
    }
    return "语言";
  }

  //语言
  String get auto {
    if (languageCode == "en") {
      return "Auto";
    }
    return "跟随系统";
  }

  //退出登录
  String get loginOut {
    if (languageCode == "en") {
      return "Login Out";
    }
    return "注销";
  }

  //提示
  String get hint {
    if (languageCode == "en") {
      return "prompt";
    }
    return "提示";
  }

  //退出登录弹窗提示
  String get logoutTip {
    if (languageCode == "en") {
      return "Do you want to quit your current account?";
    }
    return "是否退出当前账号？";
  }

  String languageByCode(String value) {
    if (value == "en_US") {
      return "English";
    }
    return "简体中文";
  }


  String get save {
    if (languageCode == "en") {
      return "Save";
    }
    return "保存";
  }

  String get hot {
    if (languageCode == "en") {
      return "Hot";
    }
    return "热门推荐";
  }

  String get recommended {
    if (languageCode == "en") {
      return "Recommended item";
    }
    return "推荐项目";
  }

  String get more {
    if (languageCode == "en") {
      return "more";
    }
    return "更多";
  }
}

//Locale代理类
class GmLocalizationsDelegate extends LocalizationsDelegate<GmLocalizations> {
  const GmLocalizationsDelegate();

  //是否支持某个Local
  @override
  bool isSupported(Locale locale) => ['en', 'zh'].contains(locale.languageCode);

  // Flutter会调用此类加载相应的Locale资源类
  @override
  Future<GmLocalizations> load(Locale locale) {
    return SynchronousFuture<GmLocalizations>(
        GmLocalizations(locale.languageCode)
    );
  }

  @override
  bool shouldReload(GmLocalizationsDelegate old) => false;
}