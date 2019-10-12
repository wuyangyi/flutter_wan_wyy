import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan_wyy/blocs/bloc_provider.dart';
import 'package:flutter_wan_wyy/blocs/main_bloc.dart';
import 'package:flutter_wan_wyy/models/system.dart';
import 'package:flutter_wan_wyy/utils/style.dart';
import 'package:flutter_wan_wyy/utils/utils.dart';
import 'package:flutter_wan_wyy/widgets/refresh_scaffold.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/rxdart.dart';

import 'home.dart';

bool isSystemInit = true;
///体系
class SystemRoute extends StatefulWidget {
  final Page page;
  SystemRoute(this.page);
  @override
  State<StatefulWidget> createState() {
    return SystemRouteState(page);
  }

}

class SystemRouteState extends State<SystemRoute> {
  RefreshController _controller = new RefreshController();
  final Page page;

  SystemRouteState(this.page);


  @override
  Widget build(BuildContext context) {
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
    if (isSystemInit) {
      isSystemInit = false;
      Observable.just(1).delay(new Duration(milliseconds: 500)).listen((_) {
        bloc.onRefresh(labelId: page.id);
      });
    }
    return StreamBuilder (
      stream: bloc.systemStream,
      builder: (BuildContext context, AsyncSnapshot<List<System>> snapshot) {
        return RefreshScaffold(
          labelId: page.id,
          loadStatus: Util.getLoadStatus(snapshot.hasError, snapshot.data),
          controller: _controller,
          enablePullUp: false,
          onRefresh: ({bool isReload}) {
            return bloc.onRefresh(labelId: page.id);
          },
          onLoadMore: (up) {
            bloc.onLoadMore(labelId: page.id);
          },
          itemCount: snapshot.data == null ? 0 : snapshot.data.length,
          itemBuilder: (BuildContext context, int index) {
            System system = snapshot.data[index];
            return SystemItem(system);
          },
        );
      },
    );
  }

}


class SystemItem extends StatelessWidget {
  final System _system;
  SystemItem(this._system);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Decorations.bottom,
      child: ListTile(
        onTap: (){},
        contentPadding: const EdgeInsets.all(0),
        title: Container(
          padding: const EdgeInsets.all(Dimens.gap_dp15),
          alignment: Alignment.centerLeft,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  _system.name,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: Dimens.font_sp16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Gaps.vGap10,
              ObjectUtil.isEmpty(_system.children) ? Container() :
              Container(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: Dimens.gap_dp5,
                  runSpacing: Dimens.gap_dp5,
                  alignment: WrapAlignment.start,
                  children: _system.children.map((data) {
                    System newData = System.fromJson(data);
                    return Chip(
                      backgroundColor: Util.getCircleBg(newData.name ?? "体系"),
                      label: new Text(
                        newData.name,
                        style: TextStyle(
                          color: Colours.title_color,
                          fontSize: Dimens.font_sp12,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}