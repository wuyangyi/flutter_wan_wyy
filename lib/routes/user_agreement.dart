import 'package:flutter/material.dart';
import 'package:flutter_wan_wyy/bean/user_info.dart';
import 'package:flutter_wan_wyy/res/strings.dart';
import 'package:flutter_wan_wyy/utils/intl_util.dart';
import 'package:flutter_wan_wyy/utils/style.dart';
import 'package:flutter_wan_wyy/utils/utils.dart';

class UserAgreementRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(IntlUtil.getString(context, Ids.userAgreement)),
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
          ),
          Container(
            margin: const EdgeInsets.all(Dimens.gap_dp15),
            padding: const EdgeInsets.all(Dimens.gap_dp15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              gradient: RadialGradient(
                colors: [Colors.white, Colors.white],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black45,
                  offset: Offset(1.0, 1.0),
                  blurRadius: 5.0,
                ),
              ],
            ),
            child: Column(
              children: <Widget>[
                Text(
                  IntlUtil.getString(context, Ids.agreement),
                  textAlign: TextAlign.center,
                  style: TextStyles.listContent2,
                ),
                Gaps.vGap10,
                Text(
                  IntlUtil.getString(context, Ids.agreementContent),
                  textAlign: TextAlign.left,
                  style: TextStyles.listExtra,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}