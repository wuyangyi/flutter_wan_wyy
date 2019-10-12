import 'package:flutter/material.dart';
import 'package:flutter_wan_wyy/blocs/bloc_provider.dart';
import 'package:flutter_wan_wyy/blocs/user_bloc.dart';
import 'package:flutter_wan_wyy/models/integral_rank.dart';
import 'package:flutter_wan_wyy/res/strings.dart';
import 'package:flutter_wan_wyy/utils/intl_util.dart';
import 'package:flutter_wan_wyy/utils/style.dart';
import 'package:flutter_wan_wyy/utils/utils.dart';
import 'package:flutter_wan_wyy/widgets/refresh_scaffold.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/rxdart.dart';

///排行榜
class IntegralRankRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return IntegralRankRouteState();
  }
}

class IntegralRankRouteState extends State<IntegralRankRoute> {
  RefreshController _controller = new RefreshController();
  String labelId = Ids.integralRanking;
  @override
  Widget build(BuildContext context) {
    final UserBloc bloc = BlocProvider.of<UserBloc>(context);
    bloc.userEventStream.listen((event) {
      if (labelId == event.labelId) {
        switch(event.status) {
          case LoadStatus.idle:
            event.isLoadMore ?
            _controller.loadComplete() :
            _controller.refreshCompleted();
            break;
          case LoadStatus.canLoading:
            break;
          case LoadStatus.loading:
            break;
          case LoadStatus.noMore:
            event.isLoadMore ?
            _controller.loadNoData() :
            _controller.resetNoData();
            break;
          case LoadStatus.failed:
            event.isLoadMore ?
            _controller.loadFailed() :
            _controller.refreshFailed();
            break;
        }
      }
    });
    Observable.just(1).delay(new Duration(milliseconds: 500)).listen((_) {
      bloc.onRefresh(labelId: labelId);
    });
    return StreamBuilder (
      stream: bloc.integralRankStream,
      builder: (BuildContext context, AsyncSnapshot<List<IntegralRank>> snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: Text(IntlUtil.getString(context, Ids.integralRanking)),
            centerTitle: true,
          ),
          body: RefreshScaffold(
            labelId: labelId,
            loadStatus: Util.getLoadStatus(snapshot.hasError, snapshot.data),
            controller: _controller,
            onRefresh: ({bool isReload}) {
              return bloc.onRefresh(labelId: labelId);
            },
            onLoadMore: (up) {
              bloc.onLoadMore(labelId: labelId);
            },
            itemCount: snapshot.data == null ? 0 : snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              IntegralRank rank = snapshot.data[index];
              return new RankingItem(rank, index);
            },
          ),
        );
      },
    );
  }
}

class RankingItem extends StatelessWidget {
  final IntegralRank _rank;
  final int index;
  RankingItem(this._rank, this.index);
  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).primaryColor;
    return Container(
      child: ListTile(
        onTap: (){},
        contentPadding: EdgeInsets.only(left: 0),
        title: Container(
          width: double.infinity,
          height: Dimens.gap_dp60,
          padding: const EdgeInsets.only(right: Dimens.gap_dp15),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: Dimens.gap_dp60,
                alignment: Alignment.center,
                child: getStartWidget(index + 1),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(left: Dimens.gap_dp10),
                child: Text(
                  _rank.username,
                  textAlign: TextAlign.left,
                  style: TextStyles.titleList,
                ),
              ),
              Expanded(flex: 1,
                child: Text(""),),
              Container(
                alignment: Alignment.centerRight,
                child: Text(
                  "${_rank.coinCount}",
                  style: TextStyle(
                    fontSize: Dimens.font_sp15,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      decoration: Decorations.bottom,
    );
  }
  
  Widget getStartWidget(int index) {
    if (index <= 3) {
      return Image.asset(Util.getImgPath("ico_rank_$index"), width: Dimens.gap_dp20,);
    }
    return Text(
      "$index",
      textAlign: TextAlign.center,
      style: TextStyles.titleList,
    );
  }
  
}