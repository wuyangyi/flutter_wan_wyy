import 'package:cached_network_image/cached_network_image.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flukit/flukit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan_wyy/blocs/bloc_provider.dart';
import 'package:flutter_wan_wyy/blocs/main_bloc.dart';
import 'package:flutter_wan_wyy/models/banner_module.dart';
import 'package:flutter_wan_wyy/models/project.dart';
import 'package:flutter_wan_wyy/net/newwork.dart';
import 'package:flutter_wan_wyy/routes/project.dart';
import 'package:flutter_wan_wyy/utils/global.dart';
import 'package:flutter_wan_wyy/utils/navigator_util.dart';
import 'package:flutter_wan_wyy/utils/style.dart';
import 'package:flutter_wan_wyy/utils/utils.dart';
import 'package:flutter_wan_wyy/widgets/refresh_scaffold.dart';
import 'package:flutter_wan_wyy/widgets/widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/rxdart.dart';

import 'home.dart';

bool isHomeInit = true;
///主页
class HomePageRoute extends StatefulWidget{
  final Page page;

  HomePageRoute(this.page);

  @override
  State<StatefulWidget> createState() {
    return HomePageRouteState(page);
  }

}

class HomePageRouteState extends State<HomePageRoute> {
  final Page page;
  HomePageRouteState(this.page);
  GmLocalizations gm;
  var color;
  RefreshController _controller = new RefreshController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    gm = GmLocalizations.of(context);
    color = Theme.of(context).primaryColor;
    final MainBloc bloc = BlocProvider.of<MainBloc>(context);
    bloc.homeEventStream.listen((event) {
      if (page.id == event.labelId) {
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
    if (isHomeInit) {
      isHomeInit = false;
      Observable.just(1).delay(new Duration(seconds: 1)).listen((_) {
        bloc.onRefresh(labelId: page.id);
        bloc.getBanner();
      });
    }
    return StreamBuilder(
      stream: bloc.bannerStream,
      builder: (BuildContext context, AsyncSnapshot<List<BannerModule>> snapshot) {
        return RefreshScaffold(
          labelId: page.id,
          loadStatus: Util.getLoadStatus(snapshot.hasError, snapshot.data),
          controller: _controller,
          onRefresh: ({bool isReload}){
            return bloc.onRefresh(labelId: page.id);
          },
          onLoadMore: (up) {
            bloc.onLoadMore(labelId: page.id);
          },
          child: ListView(
            children: <Widget>[
              buildBanner(context, snapshot.data),
              StreamBuilder(
                stream: bloc.homeDataStream,
                builder: (BuildContext context, AsyncSnapshot<List<Project>> snap) {
                  if (ObjectUtil.isEmpty(snap.data)) {
                    return new Container(height: 0.0);
                  }
                  List<Widget> _children = snap.data.map((model) {
                    return new ProjectItem(
                      model,
                    );
                  }).toList();
                  List<Widget> children = new List();
                  children.add(topHead());
                  children.add(
                    Divider(color: Colours.list_driver_color,height: 0.5,));
                  children.addAll(_children);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: children,
                  );
                },
              ),
            ],
          ),
        );
      },

    );
  }

  Widget topHead() {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(
            Icons.book,
            color: color,
          ),
          Padding(
            padding: EdgeInsets.only(left: Dimens.gap_dp10),
            child: Text(
              gm.recommended,
              style: TextStyle(
                color: color,
                fontSize: Dimens.font_sp16,
              ),
            ),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            gm.more,
            style: TextStyle(
              fontSize: Dimens.font_sp14,
            ),
          ),
          Icon(Icons.keyboard_arrow_right)
        ],
      ),
      onTap: (){
        Navigator.of(context).pushNamed("language");
      },
    );
  }

  Widget buildBanner(BuildContext context, List<BannerModule> list) {
    if (ObjectUtil.isEmpty(list)) {
      return new Container(height: 0.0);
    }
    return Column(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 16.0 / 9.0,
          child: Swiper(
            indicatorAlignment: AlignmentDirectional.topEnd,
            circular: true,
            interval: const Duration(seconds: 5),
            indicator: NumberSwiperIndicator(),
            children: list.map((model) {
              return new InkWell(
                onTap: () {
                  NavigatorUtil.pushWeb(context,
                      title: model.title, url: model.url);
                },
                child: new CachedNetworkImage(
                  fit: BoxFit.fill,
                  imageUrl: model.imagePath,
                  placeholder: (context, url) => new ProgressView(),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

}

///轮播图的数字指示器
class NumberSwiperIndicator extends SwiperIndicator {
  @override
  Widget build(BuildContext context, int index, int itemCount) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black45, borderRadius: BorderRadius.circular(20.0)),
      margin: EdgeInsets.only(top: 10.0, right: 5.0),
      padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
      child: Text("${++index}/$itemCount",
          style: TextStyle(color: Colors.white70, fontSize: 11.0)),
    );
  }
}