import 'package:flutter/material.dart';
import 'package:flutter_wan_wyy/bean/user_info.dart';
import 'package:flutter_wan_wyy/res/colors.dart';
import 'package:flutter_wan_wyy/utils/profilechangenotifier.dart';
import 'package:flutter_wan_wyy/utils/style.dart';
import 'package:flutter_wan_wyy/widgets/widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flustars/flustars.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';



class Util {

  static String getImgPath(String name, {String format: 'png'}) {
    return 'images/$name.$format';
  }

  //是否已登录
  static bool isLogin(BuildContext context) {
    return Provider.of<UserModel>(context).isLogin;
  }

  ///当BuildContext在Scaffold之前时，调用Scaffold.of(context)会报错
  static void showSnackBar(BuildContext context, String msg) {
    Scaffold.of(context).showSnackBar(
      SnackBar(content: Text("$msg")),
    );
  }

  static int getLoadStatus(bool hasError, List data) {
    if (hasError) return Status.fail;
    if (data == null) {
      return Status.loading;
    } else if (data.isEmpty) {
      return Status.empty;
    } else {
      return Status.success;
    }
  }


  static String getTimeLine(BuildContext context, int timeMillis) {
    return TimelineUtil.format(timeMillis,
        locale: Localizations.localeOf(context).languageCode,
        dayFormat: DayFormat.Common);
  }

  static double getTitleFontSize(String title) {
    if (ObjectUtil.isEmpty(title) || title.length < 10) {
      return 18.0;
    }
    int count = 0;
    List<String> list = title.split("");
    for (int i = 0, length = list.length; i < length; i++) {
      String ss = list[i];
      if (RegexUtil.isZh(ss)) {
        count++;
      }
    }

    return (count >= 10 || title.length > 16) ? 14.0 : 18.0;
  }

  //根据文字获得颜色
  static Color getCircleBg(String str) {
    String pinyin = getPinyin(str);
    return getCircleAvatarBg(pinyin);
  }

  static Color getCircleAvatarBg(String key) {
    return circleAvatarMap[key];
  }

  //文字转拼音
  static String getPinyin(String str) {
    return PinyinHelper.getShortPinyin(str).substring(0, 1).toUpperCase();
  }

}

//Toast工具类
class ToastUtil {
  //Toast
  static void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Color(0xFF9E9E9E),
        textColor: Color(0xFFFFFFFF)
    );
  }

  //Toast
  static void showToastLong(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Color(0xFF9E9E9E),
        textColor: Color(0xFFFFFFFF)
    );
  }
}