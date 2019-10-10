import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class StatusEvent {
  String labelId;
  LoadStatus status;
  int cid;
  bool isLoadMore;

  StatusEvent(this.labelId, this.status, this.isLoadMore, {this.cid});
}
