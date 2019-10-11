import 'package:flutter/material.dart';
import 'package:flutter_wan_wyy/res/strings.dart';
import 'package:flutter_wan_wyy/utils/intl_util.dart';
import 'package:flutter_wan_wyy/utils/profilechangenotifier.dart';
import 'package:flutter_wan_wyy/utils/style.dart';
import 'package:flutter_wan_wyy/utils/utils.dart';
import 'package:flutter_wan_wyy/widgets/base/base_loading.dart';
import 'package:flutter_wan_wyy/widgets/widget.dart';
import 'package:provider/provider.dart';

import 'collect.dart';
import 'home.dart';

class UserCenterRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserCenterRouteState();
  }

}

// ignore: must_be_immutable
class UserCenterRouteState extends State<UserCenterRoute> {
  UserModel userModel;
  var color;
  ScrollController controller = new ScrollController();
  double _opacity = 0.0; //透明度
  List<Page> tabs = <Page>[
    new Page(Ids.myCollect),
    new Page(Ids.myIntegral),
  ];
  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (controller.offset >= 0 && controller.offset < Dimens.user_top_height) {
        setState(() {
          _opacity = controller.offset / Dimens.user_top_height;
        });
      } else {
        setState(() {
          _opacity = 1.0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    color = Theme.of(context).primaryColor;
    userModel = Provider.of<UserModel>(context);
    return BaseLoadLayoutWidget(
      child: DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          body: CustomScrollView(
            controller: controller,
            slivers: <Widget>[
                new SliverAppBar(
                  pinned: true,
                  elevation: 0,
                  expandedHeight: Dimens.user_top_height,
                  centerTitle: true,
                  title: Container(
                    alignment: Alignment.center,
                    child: Opacity(
                      opacity: _opacity,
                      child: Row(
                        //控件里面内容主轴负轴居中显示
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        //主轴高度最小
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ClipOval(
                            // 如果已登录，则显示用户头像；若未登录，则显示默认头像
                            child: Image.asset(Util.getImgPath(
                              Util.isLogin(context) ? "ico_login_head" :"ico_default_head", ),
                              width: Dimens.gap_dp20,
                              height: Dimens.gap_dp20,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Text(
                              userModel.user.username,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.more_horiz),
                      onPressed: (){
                        ToastUtil.showToast(IntlUtil.getString(context, Ids.building));
                      },
                    ),
                  ],
                  backgroundColor: color,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      alignment: Alignment.center,
                      child: Column(
                        //控件里面内容主轴负轴居中显示
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        //主轴高度最小
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ClipOval(
                            // 如果已登录，则显示用户头像；若未登录，则显示默认头像
                            child: Image.asset(Util.getImgPath(
                              Util.isLogin(context) ? "ico_login_head" :"ico_default_head", ),
                              width: Dimens.gap_dp60,
                              height: Dimens.gap_dp60,
                            ),
                          ),
                          Gaps.vGap10,
                          Text(
                            userModel.user.username,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  bottom: TabBar(
                    isScrollable: true, //可滚动
                    tabs: tabs.map((e) => Tab(text: IntlUtil.getString(context, e.id))).toList(),
                  ),
                ),
                SliverFillRemaining(
                  child: TabBarView(
                    children: tabs.map((Page page) {
                      return buildTabView(context, page);
                    }).toList(),
                  ),
                ),
              ],
          ),
        ),
      ),
    );
  }

  // ignore: missing_return
  Widget buildTabView(BuildContext context, Page page) {
    switch (page.id) {
      case Ids.myCollect:
        return CollectRoute(page.id);
        break;
      case Ids.myIntegral:
        return Container(
          alignment: Alignment.center,
          child: Text(IntlUtil.getString(context, page.id)),
        );
        break;
    }
  }

}