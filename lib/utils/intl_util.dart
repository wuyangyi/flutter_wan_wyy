import 'package:flutter/material.dart';

import 'global.dart';
/// 推荐使用IntlUtil获取字符串.
class IntlUtil {
  static String getString(BuildContext context, String id) {
    return GmLocalizations.of(context).textById(id);
  }
}