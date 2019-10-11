import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan_wyy/bean/register_bean.dart';
import 'package:flutter_wan_wyy/bean/req_bean.dart';
import 'package:flutter_wan_wyy/bean/user_info.dart';
import 'package:flutter_wan_wyy/models/banner_module.dart';
import 'package:flutter_wan_wyy/models/project.dart';
import 'package:flutter_wan_wyy/models/user.dart';
import 'package:flutter_wan_wyy/utils/global.dart';
import 'package:flutter_wan_wyy/utils/profilechangenotifier.dart';
import 'package:flutter_wan_wyy/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:flutter_wan_wyy/net/dio_util.dart';

import 'base_resp.dart';

class NetClickUtil {
  static String USER_LOGIN = "user/login";
  static String USER_REGISTER = "user/register";
  static String USER_LOGIN_OUT = "user/logout/json";
  static String HOME_BANNER = "banner/json";
  static String HOME_LIST = "article/list/";
  static String PROJECT_LIST = "project/list/";
  static String USER_COLLECT = "lg/collect/list/";
  BuildContext context;
  NetClickUtil([BuildContext context]) {
    this.context = context;
  }

  ///登录
  Future<User> login(UserReq userReq) async {
    var response = await HttpUtils.request(USER_LOGIN + "?" + userReq.toUrl() , method: HttpUtils.POST);
    if (response == null) {
      SpUtil.putBool(BaseConstant.isLogin, false);
      SpUtil.remove(BaseConstant.keyAppToken);
      return null;
    }
    User user = User.fromJson(response["data"] as Map<String, dynamic>);
    Provider.of<UserModel>(context, listen: false).user = user;
    return user;
  }

  ///注册
  Future<User> register(UserRegister userReq) async {
    var response = await HttpUtils.request(USER_REGISTER + "?" + userReq.toUrl() , method: HttpUtils.POST);
    if (response == null) {
      SpUtil.putBool(BaseConstant.isLogin, false);
      SpUtil.remove(BaseConstant.keyAppToken);
      return null;

    }
    User user = User.fromJson(response["data"] as Map<String, dynamic>);
    Provider.of<UserModel>(context, listen: false).user = user;
    return user;
  }

  ///注销
  void outLogin() async {
    await HttpUtils.request(USER_LOGIN_OUT, method: HttpUtils.GET);
  }

  ///首页banner
  Future<List<BannerModule>> getBannerData() async {
    var response = await HttpUtils.request(HOME_BANNER , method: HttpUtils.GET);
    if (response == null) {
      return [];
    }
    List<BannerModule> banners = [];
    List data = response["data"] as List;
    for (int i = 0; i < data.length; i++) {
      banners.add(BannerModule.fromJson(data[i]));
    }
    return banners;
  }

  ///项目列表数据
  Future<List<Project>> getProjectListData(int cid, int page) async {
    var response = await HttpUtils.request(PROJECT_LIST + "$page/json?cid=$cid" , method: HttpUtils.GET);
    if (response == null) {
      return [];
    }
    List<Project> project = new List();
    List data = response["data"]["datas"] as List;
    for (int i = 0; i < data.length; i++) {
      project.add(Project.fromJson(data[i]));
    }
    return project;
  }

  ///首页列表数据
  Future<List<Project>> getHomeListData(int page) async {
    var response = await HttpUtils.request(HOME_LIST + "$page/json" , method: HttpUtils.GET);
    if (response == null) {
      return [];
    }
    List<Project> project = new List();
    List data = response["data"]["datas"] as List;
    for (int i = 0; i < data.length; i++) {
      project.add(Project.fromJson(data[i]));
    }
    return project;
  }


  ///用户收藏的列表数据
  Future<List<Project>> getCollectListData(int page) async {
    var response = await HttpUtils.request(USER_COLLECT + "$page/json" , method: HttpUtils.GET);
    if (response == null) {
      return [];
    }
    List<Project> project = new List();
    List data = response["data"]["datas"] as List;
    for (int i = 0; i < data.length; i++) {
      project.add(Project.fromJson(data[i]));
    }
    return project;
  }



}