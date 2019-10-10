import 'package:json_annotation/json_annotation.dart';

part 'banner_module.g.dart';

@JsonSerializable()
class BannerModule {
  BannerModule();

  String desc;

  num id;

  String imagePath;

  num isVisible;

  num order;

  String title;

  num type;

  String url;

  factory BannerModule.fromJson(Map<String, dynamic> json) => _$BannerModuleFromJson(json);

  Map<String, dynamic> toJson() => _$BannerModuleToJson(this);
}
