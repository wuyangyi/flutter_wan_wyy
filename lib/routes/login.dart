import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_wan_wyy/bean/req_bean.dart';
import 'package:flutter_wan_wyy/models/user.dart';
import 'package:flutter_wan_wyy/net/newwork.dart';
import 'package:flutter_wan_wyy/utils/dialog.dart';
import 'package:flutter_wan_wyy/utils/global.dart';
import 'package:flutter_wan_wyy/utils/style.dart';
import 'package:flutter_wan_wyy/utils/utils.dart';
import 'package:flutter_wan_wyy/widgets/widget.dart';

///登录页面
class LoginRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginRouteState();
  }
  
}

class LoginRouteState extends State<LoginRoute> {
  var args = true; //是否是第一次进入
  TextEditingController _unameController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  bool pwdShow = false; //密码是否显示明文
  GlobalKey _formKey = new GlobalKey<FormState>();
  bool _nameAutoFocus = true;
  TapGestureRecognizer _tapGestureRecognizer = new TapGestureRecognizer();

  @override
  void initState() {
    // 自动填充上次登录的用户名，填充后将焦点定位到密码输入框
    _unameController.text = Global.profile.lastLogin;
    if (_unameController.text != null && _unameController.text != "") {
      _nameAutoFocus = false;
    }
    super.initState();
  }

  @override
  void dispose() {
    //用到GestureRecognizer的话一定要调用其dispose方法释放资源
    _tapGestureRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context).settings.arguments != null) {
      args = ModalRoute
          .of(context)
          .settings
          .arguments; //接收传递过来的参数
    }
    var gm = GmLocalizations.of(context);
    //屏幕高度-上面图片高度
    var height = MediaQuery.of(context).size.height - 250.0;

    return Scaffold(
      resizeToAvoidBottomPadding: true, //内容随键盘移动
      backgroundColor: Colours.start_bg,
      body: Builder(
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Image.asset("images/ico_login_top.png", width: double.infinity, height: 250.0, fit: BoxFit.contain,),
                    Positioned(
                      top: Dimens.gap_dp45,
                      right: Dimens.gap_dp45,
                      child: GestureDetector(
                        child: Text(
                          args ? GmLocalizations.of(context).jump : GmLocalizations.of(context).cancel,
                          style: TextStyles.loginJump,
                        ),
                        onTap: (){
                          Navigator.of(context).pushReplacementNamed("home");
                        },
                      ),
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  height: height,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(Dimens.gap_dp20), topRight: Radius.circular(20.0))
                  ),
                  padding: const EdgeInsets.fromLTRB(Dimens.gap_dp40, Dimens.gap_dp35, Dimens.gap_dp40, 0),
                  child: Form(
                    key: _formKey,
                    autovalidate: true,
                    child: Column(
                      children: <Widget>[
                        TextField(
//                      autofocus: _nameAutoFocus,
                          controller: _unameController,
                          inputFormatters: [LengthLimitingTextInputFormatter(11)],
                          style: TextStyles.loginJump,
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                            hintText: gm.input_phone,
                            prefixIcon: Icon(Icons.person),
                            hintStyle: TextStyles.loginHint,
                            contentPadding: const EdgeInsets.all(Dimens.gap_dp15),
                          ),),
                        Padding(
                          padding: const EdgeInsets.only(top: Dimens.gap_dp15),
                          child: TextField(
                            controller: _pwdController,
//                        autofocus: !_nameAutoFocus,
                            inputFormatters: [LengthLimitingTextInputFormatter(20)],
                            style: TextStyles.loginJump,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(Dimens.gap_dp15),
                                hintText: gm.input_pwd,
                                hintStyle: TextStyles.loginHint,
                                prefixIcon: Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                      pwdShow ? Icons.visibility_off : Icons.visibility),
                                  onPressed: () {
                                    setState(() {
                                      pwdShow = !pwdShow;
                                    });
                                  },
                                )),
                            obscureText: !pwdShow,
                          ),
                        ),
                        RoundButton(
                          text: gm.login,
                          margin: EdgeInsets.only(top: Dimens.gap_dp35),
                          onPressed: () {
                            _login(context);
                          },
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: Dimens.gap_dp10),
                          alignment: Alignment.center,
                          child: Text.rich(TextSpan(
                            children: [
                              TextSpan(text: gm.new_user, style: TextStyles.newUser,),
                              TextSpan(
                                  text: gm.register,
                                  style: TextStyle(
                                    fontSize: Dimens.font_sp12,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  recognizer: _tapGestureRecognizer
                                    ..onTap = () async {
                                      var result = await Navigator.of(context).pushNamed("register");
                                      if (result != null) {
                                        Navigator.of(context).pushReplacementNamed("home");
                                      }
                                    }
                              ),
                            ],
                          )),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  //登录
  void _login(BuildContext context) async {
    String username = _unameController.text;
    String password = _pwdController.text;
    GmLocalizations gm = GmLocalizations.of(context);
    if (username.isEmpty) {
      Util.showSnackBar(context, gm.input_phone + "~");
      return;
    }
    if (password.isEmpty || password.length < 6) {
      Util.showSnackBar(context, username.isEmpty ? gm.input_pwd + "～" : gm.input_sex_pwd);
      return;
    }
    showLoadingDialog(context, gm.logging);
    User user;
    user = await NetClickUtil(context).login(new UserReq(username, password));
    Navigator.of(context).pop();
    if (user != null) {
      Global.profile.isLogin = true;
      Global.saveProfile(); //保存信息
      Util.showSnackBar(context, gm.loginSuccess + "~");
      Future.delayed(Duration(seconds: 1)).then((e) { //等待1s后关闭
        Navigator.of(context).pushReplacementNamed("home");
      });
    }
  }

}


