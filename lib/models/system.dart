import 'package:json_annotation/json_annotation.dart';

part 'system.g.dart';

@JsonSerializable()
class System {
  System();

  List children;

  num courseId;

  num id;

  String name;

  num order;

  num parentChapterId;

  bool userControlSetTop;

  num visible;

  factory System.fromJson(Map<String, dynamic> json) => _$SystemFromJson(json);

  Map<String, dynamic> toJson() => _$SystemToJson(this);
}
