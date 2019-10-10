import 'package:json_annotation/json_annotation.dart';

part 'project_type.g.dart';

@JsonSerializable()
class ProjectType {
  ProjectType();

  List children;

  num courseId;

  num id;

  String name;

  num order;

  num parentChapterId;

  bool userControlSetTop;

  num visible;

  factory ProjectType.fromJson(Map<String, dynamic> json) => _$ProjectTypeFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectTypeToJson(this);
}
