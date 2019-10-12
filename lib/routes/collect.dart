import 'package:flutter/material.dart';
import 'package:flutter_wan_wyy/blocs/bloc_provider.dart';
import 'package:flutter_wan_wyy/blocs/user_bloc.dart';
import 'package:flutter_wan_wyy/models/project.dart';
import 'package:flutter_wan_wyy/res/strings.dart';
import 'package:flutter_wan_wyy/routes/project.dart';
import 'package:flutter_wan_wyy/utils/intl_util.dart';
import 'package:flutter_wan_wyy/utils/utils.dart';
import 'package:flutter_wan_wyy/widgets/refresh_scaffold.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/rxdart.dart';

// ignore: must_be_immutable
class CollectRoute extends StatefulWidget{
  String labelId;
  CollectRoute(this.labelId);
  @override
  State<StatefulWidget> createState() {
    return CollectRouteState(labelId);
  }
}

class CollectRouteState extends State<CollectRoute> {
  RefreshController _controller = new RefreshController();
  String labelId;
  CollectRouteState(this.labelId);
  @override
  Widget build(BuildContext context) {
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
    });
    return StreamBuilder (
      stream: bloc.collectStream,
      builder: (BuildContext context, AsyncSnapshot<List<Project>> snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: Text(IntlUtil.getString(context, Ids.myCollect)),
            centerTitle: true,
          ),
          body: RefreshScaffold(
            labelId: labelId,
            loadStatus: Util.getLoadStatus(snapshot.hasError, snapshot.data),
            controller: _controller,
            onRefresh: ({bool isReload}) {
              return bloc.onRefresh(labelId: labelId);
            },
            onLoadMore: (up) {
              bloc.onLoadMore(labelId: labelId);
            },
            itemCount: snapshot.data == null ? 0 : snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              Project project = snapshot.data[index];
              return new ProjectItem(project);
            },
          ),
        );
      },
    );
  }

}