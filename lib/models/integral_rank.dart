import 'package:json_annotation/json_annotation.dart';

part 'integral_rank.g.dart';

@JsonSerializable()
class IntegralRank {
  IntegralRank();

  num coinCount;

  num rank;

  num userId;

  String username;

  factory IntegralRank.fromJson(Map<String, dynamic> json) => _$IntegralRankFromJson(json);

  Map<String, dynamic> toJson() => _$IntegralRankToJson(this);
}
