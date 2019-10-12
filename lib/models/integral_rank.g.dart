// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'integral_rank.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IntegralRank _$IntegralRankFromJson(Map<String, dynamic> json) {
  return IntegralRank()
    ..coinCount = json['coinCount'] as num
    ..rank = json['rank'] as num
    ..userId = json['userId'] as num
    ..username = json['username'] as String;
}

Map<String, dynamic> _$IntegralRankToJson(IntegralRank instance) =>
    <String, dynamic>{
      'coinCount': instance.coinCount,
      'rank': instance.rank,
      'userId': instance.userId,
      'username': instance.username
    };
