import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_wan_wyy/bean/register_bean.dart';
import 'package:flutter_wan_wyy/models/user.dart';
import 'package:flutter_wan_wyy/net/newwork.dart';
import 'package:flutter_wan_wyy/utils/dialog.dart';
import 'package:flutter_wan_wyy/utils/global.dart';
import 'package:flutter_wan_wyy/utils/style.dart';
import 'package:flutter_wan_wyy/utils/utils.dart';
import 'package:flutter_wan_wyy/widgets/widget.dart';



///注册
class RegisterRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegisterRouteState();
  }

}

class RegisterRouteState extends State<RegisterRoute> {
  TextEditingController _unameController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  TextEditingController _surePwdController = new TextEditingController();
  bool pwdShow = false; //密码是否显示明文
  bool surePwdShow = false; //确定密码是否显示明文
  GlobalKey _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                Image.asset("images/ico_login_top.png", width: double.infinity, height: 250.0, fit: BoxFit.contain,),
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
                        Padding(
                          padding: const EdgeInsets.only(top: Dimens.gap_dp15),
                          child: TextField(
                            controller: _surePwdController,
                            inputFormatters: [LengthLimitingTextInputFormatter(20)],
                            style: TextStyles.loginJump,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(Dimens.gap_dp15),
                                hintText: gm.input_sure_pwd,
                                hintStyle: TextStyles.loginHint,
                                prefixIcon: Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                      surePwdShow ? Icons.visibility_off : Icons.visibility),
                                  onPressed: () {
                                    setState(() {
                                      surePwdShow = !surePwdShow;
                                    });
                                  },
                                )),
                            obscureText: !pwdShow,
                          ),
                        ),
                        RoundButton(
                          text: gm.register,
                          margin: EdgeInsets.only(top: Dimens.gap_dp35),
                          onPressed: () {
                            _register(context);
                          },
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

  //注册
  void _register(BuildContext context) async {
    String username = _unameController.text;
    String password = _pwdController.text;
    String surepwd = _surePwdController.text;
    GmLocalizations gm = GmLocalizations.of(context);
    if (username.isEmpty || username.length < 6) {
      Util.showSnackBar(context, username.isEmpty ? gm.input_phone + "~" : gm.input_sex_phone);
      return;
    }
    if (password.isEmpty || password.length < 6) {
      Util.showSnackBar(context, username.isEmpty ? gm.input_pwd + "～" : gm.input_sex_pwd);
      return;
    }
    if (surepwd.isEmpty || surepwd.length < 6) {
      Util.showSnackBar(context, username.isEmpty ? gm.input_sure_pwd + "～" : gm.input_sex_pwd);
      return;
    }
    if (surepwd != password) {
      Util.showSnackBar(context, gm.input_sure_pwd_diff);
      return;
    }
    showLoadingDialog(context, gm.registering);
    User user = await NetClickUtil(context).register(new UserRegister(username, password, surepwd));
    Navigator.of(context).pop();
    if (user != null) {
      Global.profile.isLogin = true;
      Global.saveProfile(); //保存信息
      Util.showSnackBar(context, gm.loginSuccess + "~");
      Future.delayed(Duration(seconds: 1)).then((e) { //等待1s后关闭
        Navigator.of(context).pop(true);
      });
    }
  }

}