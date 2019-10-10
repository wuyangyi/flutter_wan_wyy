import 'package:flutter/material.dart';
import 'package:flutter_wan_wyy/bean/user_info.dart';
import 'package:flutter_wan_wyy/blocs/bloc_provider.dart';
import 'package:flutter_wan_wyy/blocs/main_bloc.dart';
import 'package:flutter_wan_wyy/utils/profilechangenotifier.dart';
import 'package:flutter_wan_wyy/utils/style.dart';
import 'package:flutter_wan_wyy/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RoundButton extends StatelessWidget {
  const RoundButton({
    Key key,
    this.width,
    this.height = 50,
    this.margin,
    this.radius,
    this.bgColor,
    this.highlightColor,
    this.splashColor,
    this.child,
    this.text,
    this.style,
    this.onPressed,
  }) : super(key: key);

  final double width;
  final double height;

  /// Empty space to surround the [decoration] and [child].
  final EdgeInsetsGeometry margin;

  final double radius;
  final Color bgColor;
  final Color highlightColor;
  final Color splashColor;

  final Widget child;

  final String text;
  final TextStyle style;

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    Color _bgColor = bgColor ?? Theme.of(context).primaryColor;
    BorderRadius _borderRadius = BorderRadius.circular(radius ?? (height / 2));
    return new Container(
      width: width,
      height: height,
      margin: margin,
      child: new Material(
        borderRadius: _borderRadius,
        color: _bgColor,
        child: new InkWell(
          borderRadius: _borderRadius,
          onTap: () => onPressed(),
          child: child ??
              new Center(
                child: new Text(
                  text,
                  style:
                  style ?? new TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
        ),
      ),
    );
  }
}

///图片加载动画
class ProgressView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new SizedBox(
        width: 24.0,
        height: 24.0,
        child: new CircularProgressIndicator(
          strokeWidth: 2.0,
        ),
      ),
    );
  }
}

///状态占位
class StatusViews extends StatelessWidget {
  const StatusViews(this.status, {Key key, this.onTap}) : super(key: key);
  final int status;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case Status.fail: //失败  显示网络异常
        return new Container(
          width: double.infinity,
          child: new Material(
            color: Colors.white,
            child: new InkWell(
              onTap: () {
                onTap();
              },
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Image.asset(
                    Util.getImgPath("ico_network_error"),
                    width: 200,
                    height: 100,
                  ),
                  Gaps.vGap10,
                  new Text(
                    "网络出问题了～ 请您查看网络设置",
                    style: TextStyles.listContent,
                  ),
                  Gaps.vGap5,
                  new Text(
                    "点击屏幕，重新加载",
                    style: TextStyles.listContent,
                  ),
                ],
              ),
            ),
          ),
        );
        break;
      case Status.loading: //加载中
        return new Container(
          alignment: Alignment.center,
          color: Colours.gray_f0,
          child: new ProgressView(),
        );
        break;
      case Status.empty: //为空
        return new Container(
          color: Colors.white,
          width: double.infinity,
          child: new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Image.asset(
                  Util.getImgPath("ico_data_empty"),
                  width: 200,
                  height: 100,
                ),
                Gaps.vGap10,
                new Text(
                  "空空如也～",
                  style: TextStyles.listContent2,
                ),
              ],
            ),
          ),
        );
        break;
      default:
        return Container();
        break;
    }
  }
}

class Status {
  static const int fail = -1;
  static const int loading = 0;
  static const int success = 1;
  static const int empty = 2;
}

///点赞控件
class LikeBtn extends StatelessWidget {
  const LikeBtn({
    Key key,
    this.labelId,
    this.id,
    this.isLike,
  }) : super(key: key);
  final String labelId;
  final int id;
  final bool isLike;

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = BlocProvider.of<MainBloc>(context);
    UserModel userModel = Provider.of<UserModel>(context);
    return new InkWell(
      onTap: () {
        if (userModel.isLogin) {
//          bloc.doCollection(labelId, id, !isLike);
        } else {

        }
      },
      child: new Icon(
        Icons.favorite,
        color: (isLike == true && userModel.isLogin)
            ? Colors.redAccent
            : Colours.gray_99,
      ),
    );
  }
}