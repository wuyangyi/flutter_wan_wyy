import 'package:flutter/material.dart';

class TextStyles {
  static TextStyle listTitle = TextStyle(
    fontSize: Dimens.font_sp16,
    color: Colours.text_dark,
    fontWeight: FontWeight.bold,
  );
  static TextStyle listContent = TextStyle(
    fontSize: Dimens.font_sp14,
    color: Colours.text_normal,
  );
  static TextStyle listContent12 = TextStyle(
    fontSize: Dimens.font_sp12,
    color: Colours.text_normal,
  );
  static TextStyle listExtra = TextStyle(
    fontSize: Dimens.font_sp12,
    color: Colours.text_gray,
  );
  static TextStyle listContent2 = TextStyle(
    fontSize: Dimens.font_sp14,
    color: Colours.text_gray,
  );

  static TextStyle loginJump = TextStyle(
    fontSize: Dimens.font_sp14,
    color: Colours.title_color,
  );

  static TextStyle titleList = TextStyle(
    fontSize: Dimens.font_sp15,
    color: Colours.title_color,
  );

  static TextStyle loginHint = TextStyle(
    fontSize: Dimens.font_sp14,
    color: Colours.hint_color,
  );
  static TextStyle newUser = TextStyle(
    fontSize: Dimens.font_sp12,
    color: Colours.hint_color,
  );

  static TextStyle loadingText = TextStyle(
    fontSize: Dimens.font_sp14,
    color: Colors.white,
    decoration: TextDecoration.none, //去掉双下划线
  );
}
//  间隔
class Gaps {
  // 水平间隔
  static Widget hGap5 = new SizedBox(width: Dimens.gap_dp5);
  static Widget hGap10 = new SizedBox(width: Dimens.gap_dp10);
  // 垂直间隔
  static Widget vGap5 = new SizedBox(height: Dimens.gap_dp5);
  static Widget vGap10 = new SizedBox(height: Dimens.gap_dp10);
}


class Colours {
  static const Color app_main = Color(0xFF666666);

  static const Color text_dark = Color(0xFF333333);
  static const Color text_normal = Color(0xFF666666);
  static const Color text_gray = Color(0xFF999999);

  static const Color start_bg = Color(0xFFe7e7e8);
  static const Color start_time_bg = Color(0x80000000);
  static const Color title_color = Color(0xFF363951);

  static const Color driver_color = Color(0xFFE7E7E);

  static const Color list_driver_color = Color(0xFFCCCCCC);

  static const Color hint_color = Color(0xFF777777);
  static const Color gray_66 = Color(0xFF666666);
  static const Color gray_99 = Color(0xFF999999);
  static const Color gray_f0 = Color(0xfff0f0f0); //<!--204-->

  static const Color divider = Color(0xffe5e5e5);

  static const Color route_bg = Color(0xFFF1F2F3);
  static const Color loading_color = Color(0x80000000);
}

class Dimens {
  static const double driver_height = 0.5;
  static const double gap_dp3 = 3.0;
  static const double gap_dp5 = 5.0;
  static const double gap_dp10 = 10.0;
  static const double gap_dp15 = 15.0;
  static const double gap_dp20 = 20.0;
  static const double gap_dp35 = 35.0;
  static const double gap_dp40 = 40.0;
  static const double gap_dp45 = 45.0;
  static const double gap_dp50 = 50.0;
  static const double gap_dp60 = 60.0;
  static const double gap_dp80 = 80.0;
  static const double user_top_height = 200.0;


  static const double font_sp12 = 12.0;
  static const double font_sp14 = 14.0;
  static const double font_sp15 = 15.0;
  static const double font_sp16 = 16.0;
}

///分割线
class Decorations {
  static Decoration bottom = BoxDecoration(
      border: Border(bottom: BorderSide(width: Dimens.driver_height, color: Colours.divider)));
}