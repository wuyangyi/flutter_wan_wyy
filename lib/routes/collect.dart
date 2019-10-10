import 'package:flutter/material.dart';
import 'package:flutter_wan_wyy/res/strings.dart';
import 'package:flutter_wan_wyy/utils/intl_util.dart';
import 'package:flutter_wan_wyy/utils/utils.dart';
import 'package:flutter_wan_wyy/widgets/base/base_loading.dart';
import 'package:flutter_wan_wyy/widgets/widget.dart';
import 'package:rxdart/rxdart.dart';

class CollectRoute extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return CollectRouteState();
  }
  
}

class CollectRouteState extends State<CollectRoute> {
  int loadStatus = Status.fail;
  bool showCenterLoad = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(IntlUtil.getString(context, Ids.collect)),
        centerTitle: true,
      ),
      body: BaseLoadLayoutWidget(
        child:Center(
          child: FlatButton(
            color: Colors.deepPurple,
            onPressed: (){
              doLoading();
            },
            child: Text("点击加载"),
          ),
        ),
        showStartCenterLoading: true,
        loadStatus: loadStatus,
        onRefresh: ({bool isReload}) {
          return onRefresh();
        },
        showCenterLoading: showCenterLoad,
      ),
    );
  }

  Future onRefresh() async {
    setState(() {
      loadStatus = Status.loading;
    });
    Observable.just(1).delay(new Duration(seconds: 3)).listen((_) {
      setState(() {
        loadStatus = Status.success;
      });
    });
  }

  Future doLoading() async {
    setState(() {
      showCenterLoad = !showCenterLoad;
    });
    Observable.just(1).delay(new Duration(seconds: 3)).listen((_) {
      setState(() {
        showCenterLoad = !showCenterLoad;
      });
    });
  }
  
}