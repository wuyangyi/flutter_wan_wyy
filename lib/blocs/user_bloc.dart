
import 'dart:collection';

import 'package:common_utils/common_utils.dart';
import 'package:flutter_wan_wyy/event/event.dart';
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
  int _collectPage = 1;
  ///**** ****** ***** collect **** ***** ****///
  ///
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
  }

  @override
  Future getData({String labelId, int page, bool isLoadMore}) {
    switch(labelId) {
      case Ids.myCollect:
        return getCollectListData(labelId, page, isLoadMore);
        break;
      case Ids.myIntegral:
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

}