import 'package:flutter/material.dart';
import 'package:flutter_wan_wyy/widgets/widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

typedef void OnLoadMore(bool up);
typedef OnRefreshCallback = Future<void> Function({bool isReload});

class RefreshScaffold extends StatefulWidget {
  const RefreshScaffold(
      {Key key,
      this.labelId,
      this.loadStatus, ///状态
      @required this.controller,
      this.enablePullUp: true, ///是否需要加载更多
      this.enablePullDown: true, ///是否需要下拉刷新
      this.onRefresh, ///下拉刷新的请求
      this.onLoadMore, ///上拉加载的请求
      this.child,
      this.itemCount,
      this.itemBuilder})
      : super(key: key);

  final String labelId;
  final int loadStatus;
  final RefreshController controller;
  final bool enablePullUp;
  final bool enablePullDown;
  final OnRefreshCallback onRefresh;
  final OnLoadMore onLoadMore;
  final Widget child;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  @override
  State<StatefulWidget> createState() {
    return new RefreshScaffoldState();
  }
}

///   with AutomaticKeepAliveClientMixin
class RefreshScaffoldState extends State<RefreshScaffold>
    with AutomaticKeepAliveClientMixin {
  bool isShowFloatBtn = false;

  @override
  void initState() {
    super.initState();
//    LogUtil.e("RefreshScaffold initState......" + widget.labelId);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.scrollController.addListener(() {
        int offset = widget.controller.scrollController.offset.toInt();
        if (offset < 480 && isShowFloatBtn) {
          isShowFloatBtn = false;
          setState(() {});
        } else if (offset > 480 && !isShowFloatBtn) {
          isShowFloatBtn = true;
          setState(() {});
        }
      });
    });
  }

  Widget buildFloatingActionButton() {
    if (widget.controller.scrollController == null ||
        widget.controller.scrollController.offset < 480) {
      return null;
    }

    return new FloatingActionButton(
        heroTag: widget.labelId,
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.keyboard_arrow_up,
        ),
        onPressed: () {
          //_controller.scrollTo(0.0);
          widget.controller.scrollController.animateTo(0.0,
              duration: new Duration(milliseconds: 300), curve: Curves.linear);
        });
  }

  @override
  Widget build(BuildContext context) {
//    LogUtil.e("RefreshScaffold build...... " + widget.labelId);
    super.build(context);
    void _onRefresh() {
      // ignore: unnecessary_statements
      widget.onRefresh(isReload: true);
    }

    void _onLoading() {
      // ignore: unnecessary_statements
      widget.onLoadMore(true);
    }

    return new Scaffold(
        body: new Stack(
          children: <Widget>[
            new SmartRefresher(
                controller: widget.controller,
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                enablePullUp: widget.enablePullUp,
                enablePullDown: widget.enablePullDown,
                child: widget.child ??
                new ListView.builder(
                  itemCount: widget.itemCount,
                  itemBuilder: widget.itemBuilder,
                )),
            new StatusViews(
              widget.loadStatus,
              onTap: () {
                widget.onRefresh(isReload: true);
              },
            ),
          ],
        ),
        floatingActionButton: buildFloatingActionButton(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
