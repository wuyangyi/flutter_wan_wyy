
import 'dart:collection';

import 'package:common_utils/common_utils.dart';
import 'package:flutter_wan_wyy/event/event.dart';
import 'package:flutter_wan_wyy/models/integral_list.dart';
import 'package:flutter_wan_wyy/models/integral_rank.dart';
import 'package:flutter_wan_wyy/models/project.dart';
import 'package:flutter_wan_wyy/net/newwork.dart';
import 'package:flutter_wan_wyy/res/strings.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc_provider.dart';

class UserBloc implements BlocBase {

  ///**** ****** ***** collect **** ***** ****///
  // ignore: close_sinks
  BehaviorSubject<List<Project>> _collect = BehaviorSubject<List<Project>>();

  Sink<List<Project>> get _collectSink => _collect.sink;

  Stream<List<Project>> get collectStream => _collect.stream;

  List<Project> _collectList;
  int _collectPage = 0;
  ///**** ****** ***** collect **** ***** ****///
  ///
  /// 
  ///**** ****** ***** 用户积分记录 **** ***** ****///
  // ignore: close_sinks
  BehaviorSubject<List<IntegralList>> _integralRecord = BehaviorSubject<List<IntegralList>>();

  Sink<List<IntegralList>> get _integralRecordSink => _integralRecord.sink;

  Stream<List<IntegralList>> get integralRecordStream => _integralRecord.stream;

  List<IntegralList> _integralRecordList;
  int _integralRecordPage = 1;
  ///**** ****** ***** 用户积分记录 **** ***** ****///
  ///
  ///
  ///**** ****** ***** 用户积分 **** ***** ****///
  // ignore: close_sinks
  BehaviorSubject<IntegralRank> _integral = BehaviorSubject<IntegralRank>();
  Sink<IntegralRank> get _integralSink => _integral.sink;
  Stream<IntegralRank> get integralStream => _integral.stream;
  ///**** ****** ***** 用户积分 **** ***** ****///
  ///
  ///**** ****** ***** 积分排行榜 **** ***** ****///
  // ignore: close_sinks
  BehaviorSubject<List<IntegralRank>> _integralRank = BehaviorSubject<List<IntegralRank>>();

  Sink<List<IntegralRank>> get _integralRankSink => _integralRank.sink;

  Stream<List<IntegralRank>> get integralRankStream => _integralRank.stream;

  List<IntegralRank> _integralRankList;
  int _integralRankPage = 1;
  ///**** ****** ***** 用户积分记录 **** ***** ****///
  ///
  ///****** ****** ****** ****** ****** ****** /
  ///****** ****** ****** ****** ****** ****** /
  // ignore: close_sinks
  BehaviorSubject<StatusEvent> _userEvent = BehaviorSubject<StatusEvent>();

  Sink<StatusEvent> get userEventSink => _userEvent.sink;

  Stream<StatusEvent> get userEventStream =>
      _userEvent.stream.asBroadcastStream();
  ///****** ****** ****** ****** ****** ****** /
  ///****** ****** ****** ****** ****** ****** /
  ///
  @override
  void dispose() {
    _userEvent.close();
    _collect.close();
    _integralRecord.close();
    _integral.close();
  }

  @override
  Future getData({String labelId, int page, bool isLoadMore}) async {
    switch(labelId) {
      case Ids.myCollect:
        return getCollectListData(labelId, page, isLoadMore);
        break;
      case Ids.myIntegral:
        return getIntegralRecordListData(labelId, page, isLoadMore);
        break;
      case Ids.integralRanking:
        return getIntegralRankListData(labelId, page, isLoadMore);
        break;
    }
  }

  @override
  Future onLoadMore({String labelId}) {
    int _page = 0;
    switch (labelId) {
      case Ids.myCollect:
        _page = _collectPage++;
        break;
      case Ids.myIntegral:
        _page = _integralRecordPage++;
        break;
      case Ids.integralRanking:
        _page = _integralRankPage++;
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
      case Ids.myCollect:
        _collectPage = 0;
        _page = _collectPage;
        break;
      case Ids.myIntegral:
        _integralRecordPage = 1;
        _page = _integralRecordPage;
        break;
      case Ids.integralRanking:
        _integralRankPage = 1;
        _page = _integralRankPage;
        break;
      default:
        break;
    }
    return getData(labelId: labelId, page: _page, isLoadMore: false);
  }

  Future getCollectListData(String labelId, int page, bool isLoadMore) async {
    return await NetClickUtil().getCollectListData(page).then((list) {
      if (_collectList == null) {
        _collectList = new List();
      }
      if(!isLoadMore) {
        _collectList.clear();
      }
      _collectList.addAll(list);
      _collectSink.add(UnmodifiableListView<Project>(_collectList));

      userEventSink.add(new StatusEvent(
          labelId,
          ObjectUtil.isEmpty(list)
              ? LoadStatus.noMore
              : LoadStatus.idle,
          isLoadMore
      ));
    }).catchError((_) {
      if (ObjectUtil.isEmpty(_collectList)) {
        _collect.sink.addError("error");
      }
      _collectPage--;
      userEventSink.add(new StatusEvent(labelId, LoadStatus.failed, isLoadMore));
    });
  }

  Future getIntegralRecordListData(String labelId, int page, bool isLoadMore) async {
    return await NetClickUtil().getIntegralListData(page).then((list) {
      if (_integralRecordList == null) {
        _integralRecordList = new List();
      }
      if(!isLoadMore) {
        _integralRecordList.clear();
      }
      _integralRecordList.addAll(list);
      _integralRecordSink.add(UnmodifiableListView<IntegralList>(_integralRecordList));

      userEventSink.add(new StatusEvent(
          labelId,
          ObjectUtil.isEmpty(list)
              ? LoadStatus.noMore
              : LoadStatus.idle,
          isLoadMore
      ));
    }).catchError((_) {
      if (ObjectUtil.isEmpty(_integralRecordList)) {
        _integralRecord.sink.addError("error");
      }
      _integralRecordPage--;
      userEventSink.add(new StatusEvent(labelId, LoadStatus.failed, isLoadMore));
    });
  }

  Future getIntegral() async {
    return await NetClickUtil().getIntegral().then((data) {
      _integralSink.add(data);
    });
  }

  Future getIntegralRankListData(String labelId, int page, bool isLoadMore) async {
    return await NetClickUtil().getIntegralRankList(page).then((list) {
      if (_integralRankList == null) {
        _integralRankList = new List();
      }
      if(!isLoadMore) {
        _integralRankList.clear();
      }
      _integralRankList.addAll(list);
      _integralRankSink.add(UnmodifiableListView<IntegralRank>(_integralRankList));

      userEventSink.add(new StatusEvent(
          labelId,
          ObjectUtil.isEmpty(list)
              ? LoadStatus.noMore
              : LoadStatus.idle,
          isLoadMore
      ));
    }).catchError((_) {
      if (ObjectUtil.isEmpty(_integralRankList)) {
        _integralRank.sink.addError("error");
      }
      _integralRankPage--;
      userEventSink.add(new StatusEvent(labelId, LoadStatus.failed, isLoadMore));
    });
  }

}