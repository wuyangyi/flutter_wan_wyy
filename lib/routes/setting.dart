import 'dart:math';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan_wyy/utils/global.dart';
import 'package:flutter_wan_wyy/utils/profilechangenotifier.dart';
import 'package:flutter_wan_wyy/utils/style.dart';
import 'package:provider/provider.dart';

class SettingRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).primaryColor;
    GmLocalizations gm = GmLocalizations.of(context);
    var localeModel = Provider.of<LocaleModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(gm.setting),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          new ExpansionTile(
            title: new Row(
              children: <Widget>[
                Icon(
                  Icons.color_lens,
                  color: Colours.gray_66,
                ),
                Padding(
                  padding: EdgeInsets.only(left: Dimens.gap_dp10),
                  child: Text(
                    gm.theme,
                  ),
                ),
              ],
            ),
            children: <Widget>[
              new Wrap(
                children: Global.themes.map((color) {
                  return InkWell(
                    onTap: (){
                      Provider.of<ThemeModel>(context).theme = color;
                    },
                    child: Container(
                      margin: EdgeInsets.all(Dimens.gap_dp5),
                      width: Dimens.gap_dp40,
                      height: Dimens.gap_dp40,
                      color: color,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                Icon(
                  Icons.language,
                  color: Colours.gray_66,
                ),
                Padding(
                  padding: EdgeInsets.only(left: Dimens.gap_dp10),
                  child: Text(
                    gm.language,
                  ),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  localeModel.locale == null ? gm.auto : gm.languageByCode(localeModel.locale),
                  style: TextStyle(
                    fontSize: Dimens.font_sp14,
                    color: Colours.gray_99,
                  ),
                ),
                Icon(Icons.keyboard_arrow_right)
              ],
            ),
            onTap: (){
              Navigator.of(context).pushNamed("language");
            },
          ),
        ],
      ),
    );
  }
  
}