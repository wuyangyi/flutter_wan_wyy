import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan_wyy/res/strings.dart';
import 'package:flutter_wan_wyy/utils/style.dart';

import 'intl_util.dart';
typedef LoadCallback = Future<bool> Function(); //加载时执行的方法
///加载动画弹窗
///message 提示词
///doLoading 加载过程中所要执行的方法，必须返回一个Future<bool> ，为true关闭加载动画，为false不关闭
showLoadingDialog(BuildContext context, {String message, LoadCallback doLoading}) async {
  showDialog(
    context: context,
    barrierDismissible: false, //点击遮罩不关闭对话框
    builder: (context) {
      return WillPopScope(
        onWillPop: () async {
          return Future.value(false); //false屏蔽返回键
        },
        child: Container(
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
                  ObjectUtil.isEmpty(message) ? "${IntlUtil.getString(context, Ids.loading)}..." : message,
                  style: TextStyles.loadingText,
                )
              ],
            ),
          ),
        ),
      );
    },
  );
  if (ObjectUtil.isNotEmpty(doLoading) && await doLoading()) {
    Navigator.pop(context);
  }


}

//加载动画弹窗2---普通样式
showLoadingDialog2(BuildContext context, String message) {
  showDialog(
    context: context,
    barrierDismissible: false, //点击遮罩不关闭对话框
    builder: (context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CircularProgressIndicator(),
            Padding(
              padding: const EdgeInsets.only(top: 26.0),
              child: Text(message),
            )
          ],
        ),
      );
    },
  );
}

///自定义动画弹窗
Future showCustomDialogUtil(BuildContext context, T) {
  return showCustomDialog(
      context: context,
      builder: (context) {
        return T;
      }
  );
}

///对话框弹出动画封装
Future<T> showCustomDialog<T> ({
  @required BuildContext context,
  bool battierDismissible = true,//点击遮罩是否关闭对话框默认为true
  WidgetBuilder builder,
}) {
  final ThemeData theme = Theme.of(context, shadowThemeOnly: true);
  return showGeneralDialog(
    context: context,
    pageBuilder: (
        BuildContext buildContext,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) {
      final Widget pageChild = Builder(builder: builder);
      return SafeArea(
        child: Builder(builder: (BuildContext context) {
          return theme != null ? Theme(data: theme, child: pageChild,) : pageChild;
        }),
      );
    },
    barrierDismissible: battierDismissible, //点击遮罩是否关闭对话框
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel, //语义化标签
    barrierColor: Colors.black45, //自定义遮罩颜色
    transitionDuration: const Duration(milliseconds: 300), //对话框打开或关闭的时长
    transitionBuilder: _buildMaterialDialogTransitions, //打开和关闭的动画
  );
}

///对话框放缩动画
Widget _buildMaterialDialogTransitions (
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
    ) {
  return ScaleTransition(
    scale: CurvedAnimation(
      parent: animation,
      curve: Curves.easeOut,
    ),
    child: child,
  );
}


//对话框（样式一）
class DialogUtil extends StatelessWidget {
  final String title;
  final String center;
  final String left;
  final String right;

  DialogUtil(this.title, this.center, this.left, this.right);


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text(title),
      ),
//      titlePadding: const EdgeInsets.only(left: 50.0), //标题填充
      titleTextStyle: TextStyle( //标题文本样式
        color: Colours.title_color,
      ),
      content: Text(center),
//      contentPadding: const EdgeInsets.all(5.0), //内容填充
      contentTextStyle: TextStyle( //内容文本样式
        color: Colors.grey,
      ),
      backgroundColor: Color(0xFFF0F0F0), //对话框背景色
      elevation: 2.0, //对话框阴影
      actions: <Widget>[ //对话框操作按钮
        FlatButton(
          child: Text(left, style: TextStyle(color: Colors.grey),),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        FlatButton(
          child: Text(right),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}
