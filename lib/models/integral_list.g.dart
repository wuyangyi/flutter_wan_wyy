// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'integral_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IntegralList _$IntegralListFromJson(Map<String, dynamic> json) {
  return IntegralList()
    ..coinCount = json['coinCount'] as num
    ..desc = json['desc'] as String
    ..id = json['id'] as num
    ..reason = json['reason'] as String
    ..type = json['type'] as num
    ..userId = json['userId'] as num
    ..userName = json['userName'] as String;
}

Map<String, dynamic> _$IntegralListToJson(IntegralList instance) =>
    <String, dynamic>{
      'coinCount': instance.coinCount,
      'desc': instance.desc,
      'id': instance.id,
      'reason': instance.reason,
      'type': instance.type,
      'userId': instance.userId,
      'userName': instance.userName
    };
