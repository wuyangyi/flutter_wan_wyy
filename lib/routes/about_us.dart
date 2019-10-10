import 'package:flutter/material.dart';
import 'package:flutter_wan_wyy/bean/user_info.dart';
import 'package:flutter_wan_wyy/res/strings.dart';
import 'package:flutter_wan_wyy/utils/intl_util.dart';
import 'package:flutter_wan_wyy/utils/style.dart';
import 'package:flutter_wan_wyy/utils/utils.dart';
import 'package:flutter_wan_wyy/widgets/com_item.dart';

class AboutUsRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ComModel github = new ComModel(
        title: 'GitHub',
        url: 'https://github.com/wuyangyi',
        extra: 'Go Star');
    ComModel userAgreement = new ComModel(
      title: IntlUtil.getString(context, Ids.userAgreement),
      pageName: Ids.userAgreement,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(IntlUtil.getString(context, Ids.about)),
        centerTitle: true,
      ),
      backgroundColor: Colours.route_bg,
      body: ListView(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            width: Dimens.gap_dp80,
            height: Dimens.gap_dp80,
            margin: const EdgeInsets.only(top: Dimens.gap_dp20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Dimens.gap_dp10),
              child: Image.asset(Util.getImgPath("ico_logo_white", format: "jpg")),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: Dimens.gap_dp10, bottom: Dimens.gap_dp10),
            child: Text(
              "${IntlUtil.getString(context, Ids.appName)} ${AppConfig.version}",
              style: TextStyles.listContent2,
              textAlign: TextAlign.center,
            ),
            decoration: Decorations.bottom,
          ),
          ComArrowItem(userAgreement),
          ComArrowItem(github),
        ],
      ),
    );
  }
}