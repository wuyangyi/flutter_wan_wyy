import 'package:json_annotation/json_annotation.dart';

part 'project.g.dart';

@JsonSerializable()
class Project {
  Project();

  String apkLink;

  num audit;

  String author;

  num chapterId;

  String chapterName;

  bool collect;

  num courseId;

  String desc;

  String envelopePic;

  bool fresh;

  num id;

  String link;

  String niceDate;

  String niceShareDate;

  String origin;

  String prefix;

  String projectLink;

  num publishTime;

  num selfVisible;

  num shareDate;

  String shareUser;

  num superChapterId;

  String superChapterName;

  List tags;

  String title;

  num type;

  num userId;

  num visible;

  num zan;

  factory Project.fromJson(Map<String, dynamic> json) => _$ProjectFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}
