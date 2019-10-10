// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) {
  return Profile()
    ..token = json['token'] as String
    ..theme = json['theme'] as num
    ..user = json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>)
    ..cache = json['cache'] == null
        ? null
        : CacheConfig.fromJson(json['cache'] as Map<String, dynamic>)
    ..lastLogin = json['lastLogin'] as String
    ..locale = json['locale'] as String
    ..isLogin = json['isLogin'] == null ? false : json['isLogin'] as bool;
}

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'token': instance.token,
      'theme': instance.theme,
      'user': instance.user,
      'cache': instance.cache,
      'lastLogin': instance.lastLogin,
      'locale': instance.locale,
      'isLogin': instance.isLogin,
    };
