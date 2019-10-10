import 'package:flutter/material.dart';
import 'package:flutter_wan_wyy/res/strings.dart';
import 'package:flutter_wan_wyy/utils/intl_util.dart';
import 'package:flutter_wan_wyy/utils/style.dart';

class UserAgreementRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(IntlUtil.getString(context, Ids.userAgreement)),
        centerTitle: true,
      ),
      backgroundColor: Colours.route_bg,
      body: Text("用户协议"),
    );
  }

}