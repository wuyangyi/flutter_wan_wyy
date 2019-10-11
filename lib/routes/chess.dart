import 'package:flutter/material.dart';
import 'package:flutter_wan_wyy/res/strings.dart';
import 'dart:math';
import 'dart:async';

import 'package:flutter_wan_wyy/utils/dialog.dart';
import 'package:flutter_wan_wyy/utils/intl_util.dart';
import 'package:flutter_wan_wyy/utils/utils.dart';


//绘制 五子棋

//棋盘
class CustomPaintRoute extends StatelessWidget {
  final double _width;
  final double _height;
  final int _lineNumber;

  CustomPaintRoute(this._width, this._height, this._lineNumber);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        size: Size(_width, _height),
        painter: MyPainter(_lineNumber), //背景画笔，会显示在子节点后面;
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  final int _lineNumber;
  MyPainter(this._lineNumber);

  @override
  void paint(Canvas canvas, Size size) {
    double eWidth = size.width / _lineNumber;
    double eHeight = size.height / _lineNumber;

    //画棋盘背景
    var mPaint = Paint()
      ..isAntiAlias = true  //是否抗锯齿
      ..style = PaintingStyle.fill  //画笔样式：填充
      ..color = Color(0x77cdb175); //画笔颜色 设置背景为纸黄色
    //Canvas | drawLine | 画线 | | drawPoint | 画点 | | drawPath | 画路径 | | drawImage | 画图像 | | drawRect | 画矩形 | | drawCircle | 画圆 | | drawOval | 画椭圆 | | drawArc | 画圆弧 |
    canvas.drawRect(Offset.zero & size, mPaint); //绘制矩形

    //画棋盘网格
    mPaint
      ..style = PaintingStyle.stroke //线
      ..color = Colors.black87
      ..strokeWidth = 1.0; //宽度

    //画横线
    for (int i = 0; i <= _lineNumber; ++i) {
      double dy = eWidth * i;
      canvas.drawLine(Offset(0, dy), Offset(size.width, dy), mPaint);
    }

    //画竖线
    for (int i = 0; i <= _lineNumber; ++i) {
      double dx = eHeight * i;
      canvas.drawLine(Offset(dx, 0), Offset(dx, size.height), mPaint);
    }
  }

  //在实际场景中正确利用此回调可以避免重绘开销，本示例我们简单的返回false
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

}

//棋子
// ignore: must_be_immutable
class ChessPiecesRoute extends StatelessWidget {
  final double _width;
  final double _height;
  final int _lineNumber;
  List<ChessItem> chess = [];

  ChessPiecesRoute(this._width, this._height, this._lineNumber, this.chess);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        size: Size(_width, _height),
        painter: ChessPainter(_lineNumber, chess),
      ),
    );
  }

}

class ChessPainter extends CustomPainter {

  Paint mPaint;
  Canvas mCanvas;
  Size mSize;

  double eWidth;
  double eHeight;
  final int _lineNumber;
  List<ChessItem> chess = [];

  ChessPainter(this._lineNumber, this.chess);

  @override
  void paint(Canvas canvas, Size size) {
    eWidth = size.width / _lineNumber;
    eHeight = size.height / _lineNumber;

    mCanvas = canvas;
    mSize = size;

    mPaint = Paint()
      ..isAntiAlias = true  //是否抗锯齿
      ..style = PaintingStyle.fill
      ..color = Color(0x00000000);
    canvas.drawRect(Offset.zero & size, mPaint); //绘制矩形

    for(int i = 0; i < chess.length; i++) {
      if (chess[i].isWhite) {
        drawWhiteChess(chess[i].position);
      } else {
        drawBackChess(chess[i].position);
      }
    }
  }

  void drawBackChess(Offset offset) {
    mPaint
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    mCanvas.drawCircle(
//      Offset(mSize.width / 2 + eWidth / 2, mSize.height / 2 - eHeight / 2),
      offset,
      min(eWidth / 2, eHeight / 2) - 2,
      mPaint,
    );

  }

  void drawWhiteChess(Offset offset) {
    mPaint
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    mCanvas.drawCircle(
//      Offset(mSize.width / 2 - eWidth / 2, mSize.height / 2 - eHeight / 2),
      offset,
      min(eWidth / 2, eHeight / 2) - 2,
      mPaint,
    );

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}

///五指棋游戏 route
class ChessPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return ChessState();
  }
}

class ChessState extends State<ChessPage> {
  static final double width = 300.0; //棋盘的宽高
  static final int line = 12; //网格的线数(10+1)
  static final int blackChess = 1; //黑棋
  static final int whiteChess = 2; //白棋
  double betweenNumber = width / line; //线与线的间距
  bool isWhite = true;
  List<List<int>> allChess = []; //棋子放置位置


  List<ChessItem> chess = [];
  GlobalKey anchorKey = GlobalKey(); //用于获取控件的位置
  @override
  void initState() {
    super.initState();
    initList();
  }

  void initList() {
    allChess.clear();
    for(int i = 0; i < line + 1; i++) {
      List<int> c = [];
      for(int j = 0; j < line + 1; j++) {
        c.add(0);
      }
      allChess.add(c);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async {
        bool isSave =  await showCustomDialogUtil(context, DialogUtil(IntlUtil.getString(context, Ids.hint), IntlUtil.getString(context, Ids.dropOut), IntlUtil.getString(context, Ids.cancel), IntlUtil.getString(context, Ids.sure)));
        if (isSave) {
          return true;
        } else {
          return false;
        }
      },

      child: Scaffold(
        appBar: AppBar(
          title: Text(IntlUtil.getString(context, Ids.gomokuGame)),
          centerTitle: true,
        ),
        backgroundColor: Color(0xFFF1F2F3),
        body: Stack(
          alignment: AlignmentDirectional.center,
          fit: StackFit.loose,
          children: <Widget>[
            Center(
              child: CustomPaintRoute(width, width, line),
            ),
            Container(
              key: anchorKey,
              alignment: Alignment.center,
              color: Colors.transparent,
              width: width,
              height: width,
              child: Listener(
                child: ChessPiecesRoute(width, width, line, chess),
                onPointerUp: (PointerUpEvent event) => setState((){
                  //得到Container的位置
                  RenderBox renderBox = anchorKey.currentContext.findRenderObject();
                  var offset = renderBox.localToGlobal(Offset.zero);
                  //点击的位置减去Container的位置，则为点击相对于Container的位置
                  var dx = event.position.dx - offset.dx;
                  var dy = event.position.dy - offset.dy;
                  //校准，让棋子在线的交叉点上
                  if (dx % betweenNumber > betweenNumber / 2) {
                    dx = (dx ~/ betweenNumber + 1) * betweenNumber;
                  } else {
                    dx = (dx ~/ betweenNumber) * betweenNumber;
                  }
                  if (dy % betweenNumber > betweenNumber / 2) {
                    dy = (dy ~/ betweenNumber + 1) * betweenNumber;
                  } else {
                    dy = (dy ~/ betweenNumber) * betweenNumber;
                  }
                  var offsetNew = Offset(dx, dy);
                  //判断点击处是否有棋子
                  for(int i = 0; i < chess.length; i++) {
                    if (chess[i].position == offsetNew) {
                      return;
                    }
                  }
                  chess.add(new ChessItem(offsetNew, isWhite));
                  allChess[dx ~/ betweenNumber][dy ~/ betweenNumber] = isWhite ? whiteChess : blackChess;
                  isWhite = !isWhite;
//                showPrint();
                  checkFinish();
                }),
              ),
            ),
            Positioned(
              top: 20.0,
              child: Text(
                IntlUtil.getString(context, isWhite ? Ids.whiteChess : Ids.blackChess),
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                ),
              ),
            ),
            Positioned(
              bottom: 20.0,
              child: FlatButton(
                color: Theme.of(context).primaryColor,
                onPressed: (){
                  setState(() {
                    chess.clear();
                    isWhite = true;
                    initList();
                  });
                },
                child: Text(IntlUtil.getString(context, Ids.restart)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //判断游戏是否结束
  void checkFinish() {

    //纵轴
    for (int i = 0; i < line + 1; i++) {
      for (int j = 0; j <= line + 1 - 5; j++) {
        checkV(i, j, blackChess);
        checkV(i, j, whiteChess);
      }
    }
    //横轴
    for (int i = 0; i <= line + 1 - 5; i++) {
      for (int j = 0; j < line + 1; j++) {
        checkH(i, j, blackChess);
        checkH(i, j, whiteChess);
      }
    }
    // \轴
    for (int i = 0; i <= line + 1 - 5; i++) {
      for (int j = 0; j <= line + 1 - 5; j++) {
        checkZ(i, j, blackChess);
        checkZ(i, j, whiteChess);
      }
    }
    // /轴
    for (int i = 0; i <= line + 1 - 5; i++) {
      for (int j = line; j >= 4; j--) {
        checkF(i, j, blackChess);
        checkF(i, j, whiteChess);
      }
    }
  }

  //纵轴5个
  Future checkV(int i, int j, int chessColor) async {
    bool isFinish = true;
    for (int k = 0; k < 5; k++) {
      if (allChess[i][j+k] != chessColor) {
        isFinish = false;
      }
    }
    if(isFinish) {
      bool isReStart =  await showCustomDialogUtil(context, DialogUtil(IntlUtil.getString(context, Ids.hint), IntlUtil.getString(context, chessColor == blackChess ? Ids.blackWin : Ids.whiteWin), IntlUtil.getString(context, Ids.cancel), IntlUtil.getString(context, Ids.sure)));
      if (isReStart) {
        setState(() {
          chess.clear();
          isWhite = true;
          initList();
        });
      }
      return;
    }
  }

  //横轴5个
  Future checkH(int i, int j, int chessColor) async {
    bool isFinish = true;
    for (int k = 0; k < 5; k++) {
      if (allChess[i+k][j] != chessColor) {
        isFinish = false;
      }
    }
    if(isFinish) {
      bool isReStart =  await showCustomDialogUtil(context, DialogUtil(IntlUtil.getString(context, Ids.hint), IntlUtil.getString(context, chessColor == blackChess ? Ids.blackWin : Ids.whiteWin), IntlUtil.getString(context, Ids.cancel), IntlUtil.getString(context, Ids.sure)));
      if (isReStart) {
        setState(() {
          chess.clear();
          isWhite = true;
          initList();
        });
      }
      return;
    }
  }

  // \轴5个
  Future checkZ(int i, int j, int chessColor) async {
    bool isFinish = true;
    for (int k = 0; k < 5; k++) {
      if (allChess[i+k][j+k] != chessColor) {
        isFinish = false;
      }
    }
    if(isFinish) {
      bool isReStart =  await showCustomDialogUtil(context, DialogUtil(IntlUtil.getString(context, Ids.hint), IntlUtil.getString(context, chessColor == blackChess ? Ids.blackWin : Ids.whiteWin), IntlUtil.getString(context, Ids.cancel), IntlUtil.getString(context, Ids.sure)));
      if (isReStart) {
        setState(() {
          chess.clear();
          isWhite = true;
          initList();
        });
      }
      return;
    }
  }

  // /轴5个
  Future checkF(int i, int j, int chessColor) async {
    bool isFinish = true;
    for (int k = 0; k < 5; k++) {
      if (allChess[i+k][j-k] != chessColor) {
        isFinish = false;
      }
    }
    if(isFinish) {
      bool isReStart =  await showCustomDialogUtil(context, DialogUtil(IntlUtil.getString(context, Ids.hint), IntlUtil.getString(context, chessColor == blackChess ? Ids.blackWin : Ids.whiteWin), IntlUtil.getString(context, Ids.cancel), IntlUtil.getString(context, Ids.sure)));
      if (isReStart) {
        setState(() {
          chess.clear();
          isWhite = true;
          initList();
        });
      }
      return;
    }
  }

//  void showPrint() {
//    for(int i = 0; i < line + 1; i++){
//      String s="";
//      for (int j = 0; j < line + 1; j++) {
//        s += "${allChess[i][j]} ";
//      }
//      print(s);
//    }
//  }

}

class ChessItem {
  ChessItem(this.position, this.isWhite);
  Offset position;
  bool isWhite;
}