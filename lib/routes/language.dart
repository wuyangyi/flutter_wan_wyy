import 'package:flutter/material.dart';
import 'package:flutter_wan_wyy/utils/global.dart';
import 'package:flutter_wan_wyy/utils/profilechangenotifier.dart';
import 'package:flutter_wan_wyy/utils/style.dart';
import 'package:provider/provider.dart';

class LanguageRoute extends StatelessWidget {
  List<String> list = new List();
  GmLocalizations gm;
  LocaleModel localeModel;
  ThemeModel themeModel;

  //构建语言选择项
  Widget _buildLanguageItem(String value) {
    return ListTile(
      title: Text(
        value == null ? gm.auto : gm.languageByCode(value),
        // 对APP当前语言进行高亮显示
        style: TextStyle(fontSize: Dimens.font_sp12, color: localeModel.locale == value ? themeModel.theme : null),
      ),
      trailing:
      localeModel.locale == value ? Icon(Icons.done, color: themeModel.theme) : null,
      onTap: () {
        // 更新locale后MaterialApp会重新build
        localeModel.locale = value;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    gm = GmLocalizations.of(context);
    localeModel = Provider.of<LocaleModel>(context);
    initList();
    themeModel = new ThemeModel();
    return Scaffold(
      appBar: AppBar(
        title: Text(gm.language),
        centerTitle: true,
      ),
      body: Builder(builder: (BuildContext context) {
        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index){
            String value = list[index];
            return _buildLanguageItem(value);
          },
        );
      }),
    );
  }
  void initList() {
    list.clear();
    list.add(null);
    list.add("zh_CN");
    list.add("en_US");
  }
}