// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner_module.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BannerModule _$BannerModuleFromJson(Map<String, dynamic> json) {
  return BannerModule()
    ..desc = json['desc'] as String
    ..id = json['id'] as num
    ..imagePath = json['imagePath'] as String
    ..isVisible = json['isVisible'] as num
    ..order = json['order'] as num
    ..title = json['title'] as String
    ..type = json['type'] as num
    ..url = json['url'] as String;
}

Map<String, dynamic> _$BannerModuleToJson(BannerModule instance) =>
    <String, dynamic>{
      'desc': instance.desc,
      'id': instance.id,
      'imagePath': instance.imagePath,
      'isVisible': instance.isVisible,
      'order': instance.order,
      'title': instance.title,
      'type': instance.type,
      'url': instance.url
    };
