import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan_wyy/bean/user_info.dart';
import 'package:flutter_wan_wyy/net/newwork.dart';
import 'package:flutter_wan_wyy/res/strings.dart';
import 'package:flutter_wan_wyy/routes/project.dart';
import 'package:flutter_wan_wyy/utils/dialog.dart';
import 'package:flutter_wan_wyy/utils/global.dart';
import 'package:flutter_wan_wyy/utils/profilechangenotifier.dart';
import 'package:flutter_wan_wyy/utils/style.dart';
import 'package:flutter_wan_wyy/utils/utils.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';

class Page {
  final String title;
  final String id;

  Page(this.id, this.title);
}

///首页
class HomeRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeRouteState();
  }

}

class HomeRouteState extends State<HomeRoute> {
  List<Page> tabs;

  @override
  Widget build(BuildContext context) {
    GmLocalizations gm = GmLocalizations.of(context);
//    UserModel userModel = Provider.of<UserModel>(context);
    tabs = <Page>[
      new Page(Ids.titleHome, gm.homePage),
      new Page(Ids.titleProject, gm.project),
      new Page(Ids.titleEvents, gm.event),
      new Page(Ids.titleSystem, gm.system),
    ];
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: MyAppBar(
          leading: Builder(
            builder: (context) {
              return GestureDetector(
                onTap: (){
                  Scaffold.of(context).openDrawer();
                },
                child: CircleAvatar(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(
                          Util.getImgPath(Util.isLogin(context) ? "ico_login_head" :"ico_default_head"),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: (){

              },
            ),
          ],
          centerTitle: true,
          title: TabBar(
            isScrollable: true,
            labelPadding: EdgeInsets.all(12.0),
            indicatorSize: TabBarIndicatorSize.label,
            tabs: tabs.map((e) => Tab(text: e.title)).toList(),

          ),
        ),
        drawer: MyDrawer(), //抽屉菜单
        body: TabBarView(
          children: tabs.map((Page page) {
            return buildTabView(context, page);
          }).toList(),
        ),
      ),
    );
  }

  Widget buildTabView(BuildContext context, Page page) {
    switch (page.id) {
      case Ids.titleHome:
        return HomePageRoute(page);
        break;
      case Ids.titleProject:
        return ProjectRoute(page);
        break;
//      case Ids.titleEvents:
//        return EventsPage(page);
//        break;
//      case Ids.titleSystem:
//        return SystemPage(page);
//        break;
      default:
        return Container(
          alignment: Alignment.center,
          child: Text(page.title),
        );
        break;
    }
  }
}



///抽屉
class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      //移除顶部padding
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildHeader(), //构建抽屉菜单头部
            Expanded(child: _buildMenus()), //构建功能菜单
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Consumer<UserModel>(
      builder: (BuildContext context, UserModel value, Widget child) {
        return GestureDetector(
          child: Container(
            color: Theme
                .of(context)
                .primaryColor,
            padding: EdgeInsets.only(top: 40, bottom: 20),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ClipOval(
                    // 如果已登录，则显示用户头像；若未登录，则显示默认头像
                    child: Image.asset(Util.getImgPath(
                      Util.isLogin(context) ? "ico_login_head" :"ico_default_head", ),
                      width: Dimens.gap_dp60,
                      height: Dimens.gap_dp60,
                    ),
                  ),
                ),
                Text(
                  Util.isLogin(context)
                      ? value.user.nickname
                      : GmLocalizations
                      .of(context)
                      .login,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          onTap: () {
            if (!Util.isLogin(context)) Navigator.of(context).pushNamed("login", arguments: true);
          },
        );
      },
    );
  }


  /// 构建菜单项
  Widget _buildMenus() {
    return Consumer<UserModel>(
      builder: (BuildContext context, UserModel userModel, Widget child) {
        var gm = GmLocalizations.of(context);
        return ListView(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(gm.setting),
              onTap: () => Navigator.pushNamed(context, "setting"),
            ),
            ListTile(
              leading: const Icon(Icons.collections),
              title: Text(gm.collect),
              onTap: () => Navigator.pushNamed(context, Ids.collect),
            ),
            ListTile(
              leading: const Icon(Icons.error_outline),
              title: Text(gm.about),
              onTap: () => Navigator.pushNamed(context, "aboutUs"),
            ),
            Util.isLogin(context) ?
            ListTile(
              leading: const Icon(Icons.power_settings_new),
              title: Text(gm.loginOut),
              onTap: () async {
                bool isOut =  await showCustomDialogUtil(context, DialogUtil(gm.hint, gm.logoutTip, gm.cancel, gm.sure));
                if(isOut) {
                  _outLogin(userModel);
                  Navigator.pop(context);
                }
              },
            ) : Container(
              height: 0,
            ),
          ],
        );
      },
    );
  }

  _outLogin(UserModel userModel) {
//    NetClickUtil().outLogin();
    userModel.outLogin();

  }

}
