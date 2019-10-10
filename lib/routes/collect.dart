import 'package:flutter/material.dart';
import 'package:flutter_wan_wyy/res/strings.dart';
import 'package:flutter_wan_wyy/utils/intl_util.dart';
import 'package:flutter_wan_wyy/utils/utils.dart';

class CollectRoute extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return CollectRouteState();
  }
  
}

class CollectRouteState extends State<CollectRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(IntlUtil.getString(context, Ids.collect)),
        centerTitle: true,
      ),
      body: Center(
        child: Image.asset(Util.getImgPath("ico_route_building")),
      ),
    );
  }
  
}