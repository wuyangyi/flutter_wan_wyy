
import 'dart:collection';

import 'package:common_utils/common_utils.dart';
import 'package:flutter_wan_wyy/event/event.dart';
import 'package:flutter_wan_wyy/models/banner_module.dart';
import 'package:flutter_wan_wyy/models/project.dart';
import 'package:flutter_wan_wyy/models/system.dart';
import 'package:flutter_wan_wyy/net/newwork.dart';
import 'package:flutter_wan_wyy/res/strings.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc_provider.dart';

class MainBloc implements BlocBase {

  ///**** ****** ***** home **** ***** ****///
  ///
  /// ///**** ****** ***** banner **** ***** ****///
  // ignore: close_sinks
  BehaviorSubject<List<BannerModule>> _banner = BehaviorSubject<List<BannerModule>>();
  Sink<List<BannerModule>> get _bannerSink => _banner.sink;
  Stream<List<BannerModule>> get bannerStream => _banner.stream;
  /// ///**** ****** ***** banner **** ***** ****///
  ///
// ignore: close_sinks
  BehaviorSubject<List<Project>> _homeData = BehaviorSubject<List<Project>>();

  Sink<List<Project>> get _homeDataSink => _homeData.sink;

  Stream<List<Project>> get homeDataStream => _homeData.stream;

  List<Project> _homeDataList;
  int _homeDataPage = 0;
  ///**** ****** ***** home **** ***** ****///
  ///**** ****** ***** project **** ***** ****///
  // ignore: close_sinks
  BehaviorSubject<List<Project>> _project = BehaviorSubject<List<Project>>();

  Sink<List<Project>> get _projectSink => _project.sink;

  Stream<List<Project>> get projectStream => _project.stream;

  List<Project> _projectList;
  int _projectPage = 1;
  ///**** ****** ***** project **** ***** ****///
  ///
  ///**** ****** ***** system **** ***** ****///
  // ignore: close_sinks
  BehaviorSubject<List<System>> _system = BehaviorSubject<List<System>>();

  Sink<List<System>> get _systemSink => _system.sink;

  Stream<List<System>> get systemStream => _system.stream;

  List<System> _systemList;
  ///**** ****** *****   ///**** ****** ***** system **** ***** ****/// **** ***** ****///


  ///****** ****** ****** ****** ****** ****** /
  ///****** ****** ****** ****** ****** ****** /
  BehaviorSubject<StatusEvent> _homeEvent = BehaviorSubject<StatusEvent>();

  Sink<StatusEvent> get homeEventSink => _homeEvent.sink;

  Stream<StatusEvent> get homeEventStream =>
      _homeEvent.stream.asBroadcastStream();
  ///****** ****** ****** ****** ****** ****** /
  ///****** ****** ****** ****** ****** ****** /

  @override
  void dispose() {
    _project.close();
    _homeEvent.close();
    _homeData.close();
    _banner.close();
    _system.close();
  }

  @override
  Future getData({String labelId, int page, bool isLoadMore}) async {
    switch(labelId) {
      case Ids.titleHome:
        return getHomeListData(labelId, page, isLoadMore);
        break;
      case Ids.titleProject:
        return getProjectList(labelId, page, isLoadMore);
        break;
      case Ids.titleEvents:
        break;
      case Ids.titleSystem:
        return getSystemList(labelId);
        break;
    }
  }

  @override
  Future onLoadMore({String labelId}) {
    int _page = 0;
    switch (labelId) {
      case Ids.titleHome:
        _page = _homeDataPage++;
        break;
      case Ids.titleProject:
        _page = _projectPage++;
        break;
      case Ids.titleEvents:
        break;
      case Ids.titleSystem:
        break;
      default:
        break;
    }
    return getData(labelId: labelId, page: _page, isLoadMore: true);
  }

  @override
  Future onRefresh({String labelId}) {
    int _page = 0;
    switch (labelId) {
      case Ids.titleHome:
        _homeDataPage = 0;
        _page = _homeDataPage;
        break;
      case Ids.titleProject:
        _projectPage = 1;
        _page = _projectPage;
        break;
      case Ids.titleEvents:
        break;
      case Ids.titleSystem:
        break;
      default:
        break;
    }
    return getData(labelId: labelId, page: _page, isLoadMore: false);
  }

  ///获得项目列表数据
  Future getProjectList(String labelId, int page, bool isLoadMore) async {
    return await NetClickUtil().getProjectListData(294, page).then((list) {
      if (_projectList == null) {
        _projectList = new List();
      }
      if(!isLoadMore) {
        _projectList.clear();
      }
      _projectList.addAll(list);
      _projectSink.add(UnmodifiableListView<Project>(_projectList));

      homeEventSink.add(new StatusEvent(
        labelId,
        ObjectUtil.isEmpty(list)
            ? LoadStatus.noMore
          : LoadStatus.idle,
        isLoadMore
      ));
    }).catchError((_) {
      if (ObjectUtil.isEmpty(_projectList)) {
        _project.sink.addError("error");
      }
      _projectPage--;
      homeEventSink.add(new StatusEvent(labelId, LoadStatus.failed, isLoadMore));
    });
  }

  ///获取首页列表数据
  Future getHomeListData(String labelId, int page, bool isLoadMore) async {
    return await NetClickUtil().getHomeListData(page).then((list) {
      if (_homeDataList == null) {
        _homeDataList = new List();
      }
      if(!isLoadMore) {
        _homeDataList.clear();
      }
      _homeDataList.addAll(list);
      _homeDataSink.add(UnmodifiableListView<Project>(_homeDataList));

      homeEventSink.add(new StatusEvent(
          labelId,
          ObjectUtil.isEmpty(list)
              ? LoadStatus.noMore
              : LoadStatus.idle,
          isLoadMore
      ));
    }).catchError((_) {
      if (ObjectUtil.isEmpty(_homeDataList)) {
        _homeData.sink.addError("error");
      }
      _homeDataPage--;
      homeEventSink.add(new StatusEvent(labelId, LoadStatus.failed, isLoadMore));
    });
  }

  Future getBanner() async {
    return await NetClickUtil().getBannerData().then((list) {
      _bannerSink.add(UnmodifiableListView<BannerModule>(list));
    });
  }

  ///获得体系列表数据
  Future getSystemList(String labelId) async {
    return await NetClickUtil().getSystemList().then((list) {
      if (_systemList == null) {
        _systemList = new List();
      }
      _systemList.clear();
      _systemList.addAll(list);
      _systemSink.add(UnmodifiableListView<System>(_systemList));

      homeEventSink.add(new StatusEvent(
          labelId,
          ObjectUtil.isEmpty(list)
              ? LoadStatus.noMore
              : LoadStatus.idle,
          false
      ));
    }).catchError((_) {
      if (ObjectUtil.isEmpty(_systemList)) {
        _system.sink.addError("error");
      }
      homeEventSink.add(new StatusEvent(labelId, LoadStatus.failed, false));
    });
  }

}