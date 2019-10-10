import 'package:flutter/material.dart';
import 'package:flutter_wan_wyy/res/strings.dart';
import 'package:flutter_wan_wyy/utils/intl_util.dart';
import 'package:flutter_wan_wyy/utils/style.dart';

import '../refresh_scaffold.dart';
import '../widget.dart';

//集成加载的基类
// ignore: must_be_immutable
class BaseLoadLayoutWidget extends StatefulWidget {
  bool showStartCenterLoading; //是否显示开始的加载
  bool showCenterLoading; //显示内容之上的加载
  Widget child;
  int loadStatus; //加载状态Status
  OnRefreshCallback onRefresh;
  BaseLoadLayoutWidget({
    this.showCenterLoading = false,
    this.showStartCenterLoading = false,
    this.child,
    this.loadStatus,
    this.onRefresh
  });

  @override
  State<StatefulWidget> createState() {
    return BaseLoadLayoutWidgetState();
  }
}

class BaseLoadLayoutWidgetState extends State<BaseLoadLayoutWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _buildContext(),
        _loadData(),
      ],
    );
  }

  //内容或者加载
  Widget _buildContext() {
    if (widget.showStartCenterLoading && widget.loadStatus == Status.success) {
      return widget.child;
    } else {
      return new StatusViews(
        widget.loadStatus,
        onTap: () {
          widget.onRefresh(isReload: true);
        },
      );
    }
  }


  //布局上的加载动画
  Widget _loadData() {
    if (widget.showCenterLoading) {
      return Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        color: Color(0x60000000),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(10.0)
          ),
          child: Column(
            //控件里面内容主轴负轴居中显示
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            //主轴高度最小
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircularProgressIndicator(),
              Gaps.vGap10,
              Text(
                "${IntlUtil.getString(context, Ids.loading)}...",
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
      );
    } else {
      return Container(width: 0, height: 0,);
    }
  }

}