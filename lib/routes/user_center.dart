import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan_wyy/blocs/bloc_provider.dart';
import 'package:flutter_wan_wyy/blocs/user_bloc.dart';
import 'package:flutter_wan_wyy/models/integral_list.dart';
import 'package:flutter_wan_wyy/models/integral_rank.dart';
import 'package:flutter_wan_wyy/res/strings.dart';
import 'package:flutter_wan_wyy/utils/event_bus.dart';
import 'package:flutter_wan_wyy/utils/intl_util.dart';
import 'package:flutter_wan_wyy/utils/navigator_util.dart';
import 'package:flutter_wan_wyy/utils/profilechangenotifier.dart';
import 'package:flutter_wan_wyy/utils/style.dart';
import 'package:flutter_wan_wyy/utils/utils.dart';
import 'package:flutter_wan_wyy/widgets/base/base_loading.dart';
import 'package:flutter_wan_wyy/widgets/refresh_scaffold.dart';
import 'package:flutter_wan_wyy/widgets/widget.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/rxdart.dart';

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
  RefreshController _controller = new RefreshController();
  double _opacity = 0.0; //透明度
  String labelId = Ids.myIntegral;
  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (controller.offset < Dimens.user_top_height / 2) {
        _opacity = 0.0;
      } else if (controller.offset < Dimens.user_top_height) {
        _opacity = (controller.offset - Dimens.user_top_height / 2) / (Dimens.user_top_height / 2);
      } else {
        _opacity = 1.0;
      }
      bus.emit(EventBusId.USER_CENTER_OPACITY, _opacity);
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    color = Theme.of(context).primaryColor;
    userModel = Provider.of<UserModel>(context);
    final UserBloc bloc = BlocProvider.of<UserBloc>(context);
    bloc.userEventStream.listen((event) {
      if (labelId == event.labelId) {
        switch(event.status) {
          case LoadStatus.idle:
            event.isLoadMore ?
            _controller.loadComplete() :
            _controller.refreshCompleted();
            break;
          case LoadStatus.canLoading:
            break;
          case LoadStatus.loading:
            break;
          case LoadStatus.noMore:
            event.isLoadMore ?
            _controller.loadNoData() :
            _controller.resetNoData();
            break;
          case LoadStatus.failed:
            event.isLoadMore ?
            _controller.loadFailed() :
            _controller.refreshFailed();
            break;
        }
      }
    });
    Observable.just(1).delay(new Duration(milliseconds: 500)).listen((_) {
      bloc.onRefresh(labelId: labelId);
      bloc.getIntegral();
    });
    return StreamBuilder(
      stream: bloc.integralRecordStream,
      builder: (BuildContext context, AsyncSnapshot<List<IntegralList>> snapshot) {
        return !snapshot.hasData ? StatusViews(Status.loading) : RefreshScaffold(
          labelId: labelId,
          loadStatus: Util.getLoadStatus(snapshot.hasError, snapshot.data),
          controller: _controller,
          onRefresh: ({bool isReload}) {
            return bloc.onRefresh(labelId: labelId);
          },
          onLoadMore: (up) {
            bloc.onLoadMore(labelId: labelId);
          },
          child: CustomScrollView(
            controller: controller,
            slivers: <Widget>[
              new SliverAppBar(
                pinned: true,
                elevation: 0,
                expandedHeight: Dimens.user_top_height,
                centerTitle: true,
                title: Container(
                  alignment: Alignment.center,
                  child: TextWidget(0.0, IntlUtil.getString(context, Ids.myIntegral)),
                ),
                actions: <Widget>[
                  new PopupMenuButton(
                      padding: const EdgeInsets.all(0.0),
                      onSelected: (value){
                        switch(value) {
                          case Ids.integralRanking: //排行榜
                          NavigatorUtil.pushPage(context, Ids.integralRanking);
                          break;
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                        new PopupMenuItem<String>(
                            value: Ids.integralRanking,
                            child: ListTile(
                                contentPadding: EdgeInsets.all(0.0),
                                dense: false,
                                title: new Container(
                                  alignment: Alignment.center,
                                  child: new Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.flag,
                                        color: Colours.gray_66,
                                        size: 22.0,
                                      ),
                                      Gaps.hGap10,
                                      Text(
                                        IntlUtil.getString(context, Ids.integralRanking),
                                        style: TextStyles.listContent,
                                      )
                                    ],
                                  ),
                                ))),
                      ])
                ],
                backgroundColor: color,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(Util.getImgPath("user_page_top_bg_new")),
                        fit: BoxFit.cover,
                      ),
                    ),
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
                        Gaps.vGap10,
                        StreamBuilder(
                          stream: bloc.integralStream,
                          builder: (BuildContext context, AsyncSnapshot<IntegralRank> snap) {
                            return Text(
                              ObjectUtil.isEmpty(snap.data) ? "" : "${IntlUtil.getString(context, Ids.integral)}：${snap.data.coinCount}   ${IntlUtil.getString(context, Ids.integralRank)}：${snap.data.rank}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: Dimens.font_sp12,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverFixedExtentList(
                itemExtent: Dimens.gap_dp80,
                delegate: new SliverChildBuilderDelegate((BuildContext context, int index){
                  return Container(
                    padding: const EdgeInsets.all(Dimens.gap_dp15),
                    child: Stack(
                      alignment: AlignmentDirectional.centerEnd,
                      children: <Widget>[
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Text(
                            snapshot.data[index].reason,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colours.title_color,
                              fontSize: Dimens.font_sp16,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          bottom: 0,
                          child: Text(
                            snapshot.data[index].desc.substring(0, 19),
                            textAlign: TextAlign.left,
                            style: TextStyles.listContent2,
                          ),
                        ),
                        Text(
                          "+ ${snapshot.data[index].coinCount}",
                          style: TextStyle(
                              color: color,
                              fontSize: 13.0
                          ),
                        ),
                      ],
                    ),
                    decoration: Decorations.bottom,
                  );
                },
                childCount: snapshot.data.length),
              ),
            ],
          ),
        );
      },
    );
  }

}