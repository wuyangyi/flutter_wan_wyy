import 'package:flutter/material.dart';
import 'package:flutter_wan_wyy/utils/navigator_util.dart';
import 'package:flutter_wan_wyy/utils/style.dart';

class ComArrowItem extends StatelessWidget {
  const ComArrowItem(this.model, {Key key}) : super(key: key);
  final ComModel model;

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Material(
        color: Colors.white,
        child: new ListTile(
          onTap: () {
            if (model.pageName == null) {
              NavigatorUtil.pushWeb(context, title: model.title, url: model.url);
            } else {
              NavigatorUtil.pushPage(context, model.pageName);
            }
          },
          title: new Text(model.title == null ? "" : model.title),
          trailing: new Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Text(
                model.extra == null ? "" : model.extra,
                style: TextStyle(color: Colors.grey, fontSize: 14.0),
              ),
              new Icon(
                Icons.navigate_next,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
      decoration: Decorations.bottom,
    );
  }
}



class ComModel {
  String version; //版本
  String title; //左边文字
  String content;
  String extra; //右边文字
  String url; //web跳转链接
  String imgUrl;
  String author; //作者
  String updatedAt;

  int typeId;
  String titleId;

  String pageName;

  ComModel(
      {this.version,
        this.title,
        this.content,
        this.extra,
        this.url,
        this.imgUrl,
        this.author,
        this.updatedAt,
        this.typeId,
        this.titleId,
        this.pageName});

  ComModel.fromJson(Map<String, dynamic> json)
      : version = json['version'],
        title = json['title'],
        content = json['content'],
        extra = json['extra'],
        url = json['url'],
        imgUrl = json['imgUrl'],
        author = json['author'],
        updatedAt = json['updatedAt'];

  Map<String, dynamic> toJson() => {
    'version': version,
    'title': title,
    'content': content,
    'extra': extra,
    'url': url,
    'imgUrl': imgUrl,
    'author': author,
    'updatedAt': updatedAt,
  };

  @override
  String toString() {
    StringBuffer sb = new StringBuffer('{');
    sb.write("\"version\":\"$version\"");
    sb.write(",\"title\":\"$title\"");
    sb.write(",\"content\":\"$content\"");
    sb.write(",\"url\":\"$url\"");
    sb.write(",\"imgUrl\":\"$imgUrl\"");
    sb.write(",\"author\":\"$author\"");
    sb.write(",\"updatedAt\":\"$updatedAt\"");
    sb.write('}');
    return sb.toString();
  }
}