import 'package:json_annotation/json_annotation.dart';

part 'integral_list.g.dart';

@JsonSerializable()
class IntegralList {
  IntegralList();

  num coinCount;

  num date;

  String desc;

  num id;

  String reason;

  num type;

  num userId;

  String userName;

  factory IntegralList.fromJson(Map<String, dynamic> json) => _$IntegralListFromJson(json);

  Map<String, dynamic> toJson() => _$IntegralListToJson(this);
}
