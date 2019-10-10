import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_wan_wyy/blocs/bloc_provider.dart';
import 'package:flutter_wan_wyy/blocs/main_bloc.dart';
import 'package:flutter_wan_wyy/res/strings.dart';
import 'package:flutter_wan_wyy/routes/register.dart';
import 'package:flutter_wan_wyy/routes/setting.dart';
import 'package:flutter_wan_wyy/routes/user_agreement.dart';
import 'package:flutter_wan_wyy/utils/global.dart';
import 'package:flutter_wan_wyy/utils/profilechangenotifier.dart';
import 'package:flutter_wan_wyy/utils/style.dart';
import 'package:flutter_wan_wyy/utils/utils.dart';
import 'package:provider/provider.dart';

import 'about_us.dart';
import 'collect.dart';
import 'home.dart';
import 'language.dart';
import 'login.dart';

void main() => Global.init().then((e) => runApp(BlocProvider(child: MyApp(), bloc: MainBloc())));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildCloneableWidget>[
        ChangeNotifierProvider.value(value: ThemeModel()),
        ChangeNotifierProvider.value(value: UserModel()),
        ChangeNotifierProvider.value(value: LocaleModel()),
      ],
      child: Consumer2<ThemeModel, LocaleModel>(
        builder: (BuildContext context, themeModel, localeModel, Widget child) {
          return MaterialApp(
            theme: ThemeData(
              primarySwatch: themeModel.theme,
            ),
//            onGenerateTitle: (context){
//              return GmLocalizations.of(context).title;
//            },
            home: StartRoute(), //启动页
            locale: localeModel.getLocale(),
            //我们只支持美国英语和中文简体
            supportedLocales: [
              const Locale('en', 'US'), // 美国英语
              const Locale('zh', 'CN'), // 中文简体
              //其它Locales
            ],
            localizationsDelegates: [
              // 本地化的代理类
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GmLocalizationsDelegate()
            ],
            localeResolutionCallback:
                (Locale _locale, Iterable<Locale> supportedLocales) {
              if (localeModel.getLocale() != null) {
                //如果已经选定语言，则不跟随系统
                return localeModel.getLocale();
              } else {

                Locale locale;
                //APP语言跟随系统语言，如果系统语言不是中文简体或美国英语，
                //则默认使用简体中文
                if (supportedLocales.contains(_locale)) {
                  locale= _locale;
                } else {
                  locale= Locale('zh', 'CN');
                }
                return locale;
              }
            },
            // 注册命名路由表
            routes: <String, WidgetBuilder>{
              "login": (context) => LoginRoute(), ///登录
              "register": (context) => RegisterRoute(),  ///注册
              "home": (context) => HomeRoute(), ///首页
              "setting": (context) => SettingRoute(),  ///设置
              "language": (context) => LanguageRoute(), ///语言
              "aboutUs": (context) => AboutUsRoute(), ///关于
              Ids.userAgreement: (context) => UserAgreementRoute(), ///用户协议
              Ids.collect: (context) => CollectRoute(), //收藏
            },
          );
        },
      ),
    );
  }
}

class StartRoute extends StatefulWidget {

  @override
  _StartRouteState createState() => _StartRouteState();
}

class _StartRouteState extends State<StartRoute> {
  TimerUtil timerUtil;
  int mTime = 5;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.start_bg,
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Stack(
              children: <Widget>[
                Image.asset("images/ico_login_top.png", width: double.infinity, height: double.infinity, fit: BoxFit.cover,),
                Positioned(
                  right: Dimens.gap_dp35,
                  top: Dimens.gap_dp35,
                  child: GestureDetector(
                    child: CircleAvatar(
                      backgroundColor: Colours.start_time_bg,
                      child: Text(
                        GmLocalizations.of(context).jump + "\n$mTime s",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: Dimens.font_sp12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onTap: () {//跳过点击事件
                      _cancelTimer();
                      //页面跳转
                      if (Util.isLogin(context)) {
                        Navigator.of(context).pushReplacementNamed("home");
                      } else {
                        Navigator.of(context).pushReplacementNamed("login", arguments:true);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colours.start_bg,
            padding: const EdgeInsets.only(bottom: Dimens.gap_dp20),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Text(""),
                ),
                Container(
                  alignment: Alignment.center,
                  width: Dimens.gap_dp35,
                  height: Dimens.gap_dp35,
                  margin: const EdgeInsets.only(right: Dimens.gap_dp10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                      image: AssetImage("images/ico_logo_white.jpg")
                    )
                  ),
                ),
                Center (
                  child: Text(
                    GmLocalizations.of(context).appName,
                    style: TextStyles.loginJump,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(""),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _startTimer() {
    if (timerUtil == null) {
      timerUtil = TimerUtil();
      timerUtil.setInterval(1000); //设置时间间隔1s
      timerUtil.setTotalTime(5000); //总时间
      timerUtil.setOnTimerTickCallback((time){ //回调
        setState(() {
          mTime = mTime - 1;
          if (mTime == 0) {
            _cancelTimer();
            //页面跳转
            if (Util.isLogin(context)) {
              Navigator.of(context).pushReplacementNamed("home");
            } else {
              //替换当前路由进入登录页面
              Navigator.of(context).pushReplacementNamed("login", arguments:true);
            }
          }
        });
      });
    }
    timerUtil.startTimer();
  }

  void _cancelTimer() {
    if (timerUtil != null && timerUtil.isActive()) { //timerUtil不为空且timerUtil是启动状态
      timerUtil.cancel();
    }
  }
}
