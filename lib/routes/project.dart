import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan_wyy/blocs/bloc_provider.dart';
import 'package:flutter_wan_wyy/blocs/main_bloc.dart';
import 'package:flutter_wan_wyy/models/project.dart';
import 'package:flutter_wan_wyy/utils/navigator_util.dart';
import 'package:flutter_wan_wyy/utils/style.dart';
import 'package:flutter_wan_wyy/utils/utils.dart';
import 'package:flutter_wan_wyy/widgets/refresh_scaffold.dart';
import 'package:flutter_wan_wyy/widgets/widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/rxdart.dart';

import 'home.dart';

bool isReposInit = true;
///项目
class ProjectRoute extends StatefulWidget {
  final Page _page;

  ProjectRoute(this._page);
  @override
  State<StatefulWidget> createState() {
    return ProjectRouteState(_page);
  }

}

class ProjectRouteState extends State<ProjectRoute> {
  RefreshController _controller = new RefreshController();
  final Page page;

  ProjectRouteState(this.page);


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
    if (isReposInit) {
      isReposInit = false;
      Observable.just(1).delay(new Duration(milliseconds: 500)).listen((_) {
        bloc.onRefresh(labelId: page.id);
      });
    }
    return StreamBuilder (
      stream: bloc.projectStream,
      builder: (BuildContext context, AsyncSnapshot<List<Project>> snapshot) {
        return RefreshScaffold(
          labelId: page.id,
          loadStatus: Util.getLoadStatus(snapshot.hasError, snapshot.data),
          controller: _controller,
          onRefresh: ({bool isReload}) {
            return bloc.onRefresh(labelId: page.id);
          },
          onLoadMore: (up) {
            bloc.onLoadMore(labelId: page.id);
          },
          itemCount: snapshot.data == null ? 0 : snapshot.data.length,
          itemBuilder: (BuildContext context, int index) {
            Project project = snapshot.data[index];
            return new ProjectItem(project);
          },
        );
      },
    );
  }

}



class ProjectItem extends StatelessWidget {
  const ProjectItem(
      this.model, {
        this.labelId,
        Key key,
      }) : super(key: key);
  final String labelId;
  final Project model;

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: () {
        NavigatorUtil.pushWeb(context,
            title: model.title, url: model.link);
      },
      child: new Container(
          height: 160.0,
          padding: EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 10),
          child: new Row(
            children: <Widget>[
              new Expanded(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(
                        model.title,
                        maxLines: model.desc == null || model.desc.isEmpty ? 2 : 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.listTitle,
                      ),
                      Gaps.vGap10,
                      new Expanded(
                        flex: 1,
                        child: new Text(
                          model.desc,
                          maxLines: 3,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.listContent,
                        ),
                      ),
                      Gaps.vGap5,
                      new Row(
                        children: <Widget>[
                          LikeBtn(
                            labelId: labelId,
                            id: model.id,
                            isLike: model.collect,
                          ),
                          Gaps.hGap10,
                          new Text(
                            model.author,
                            style: TextStyles.listExtra,
                          ),
                          Gaps.hGap10,
                          new Text(
                            Util.getTimeLine(context, model.publishTime),
                            style: TextStyles.listExtra,
                          ),
                        ],
                      )
                    ],
                  )),
              model.envelopePic == null || model.envelopePic.isEmpty ?
              new Container(
                width: 72,
                height: 72,
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 12.0),
                child: new CircleAvatar(
                  radius: 28.0,
                  backgroundColor:
                  Util.getCircleBg(model.superChapterName ?? "文章"),
                  child: new Padding(
                    padding: EdgeInsets.all(5.0),
                    child: new Text(
                      model.superChapterName ?? "文章",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 11.0),
                    ),
                  ),
                ),
              )   :
              new Container(
                width: 72,
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 10.0),
                child: new CachedNetworkImage(
                  width: 72,
                  height: 128,
                  fit: BoxFit.fill,
                  imageUrl: model.envelopePic,
                  placeholder: (BuildContext context, String url) {
                    return new ProgressView();
                  },
                  errorWidget:
                      (BuildContext context, String url, Object error) {
                    return new Icon(Icons.error);
                  },
                ),
              )
            ],
          ),
          decoration: new BoxDecoration(
              color: Colors.white,
              border: new Border(
                  bottom:
                  new BorderSide(width: 0.33, color: Colours.divider)))),
    );
  }
}
