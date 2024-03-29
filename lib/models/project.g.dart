// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Project _$ProjectFromJson(Map<String, dynamic> json) {
  return Project()
    ..apkLink = json['apkLink'] as String
    ..audit = json['audit'] as num
    ..author = json['author'] as String
    ..chapterId = json['chapterId'] as num
    ..chapterName = json['chapterName'] as String
    ..collect = json['collect'] as bool
    ..courseId = json['courseId'] as num
    ..desc = json['desc'] as String
    ..envelopePic = json['envelopePic'] as String
    ..fresh = json['fresh'] as bool
    ..id = json['id'] as num
    ..link = json['link'] as String
    ..niceDate = json['niceDate'] as String
    ..niceShareDate = json['niceShareDate'] as String
    ..origin = json['origin'] as String
    ..originId = json['originId'] as num
    ..prefix = json['prefix'] as String
    ..projectLink = json['projectLink'] as String
    ..publishTime = json['publishTime'] as num
    ..selfVisible = json['selfVisible'] as num
    ..shareDate = json['shareDate'] as num
    ..shareUser = json['shareUser'] as String
    ..superChapterId = json['superChapterId'] as num
    ..superChapterName = json['superChapterName'] as String
    ..tags = json['tags'] as List
    ..title = json['title'] as String
    ..type = json['type'] as num
    ..userId = json['userId'] as num
    ..visible = json['visible'] as num
    ..zan = json['zan'] as num;
}

Map<String, dynamic> _$ProjectToJson(Project instance) => <String, dynamic>{
      'apkLink': instance.apkLink,
      'audit': instance.audit,
      'author': instance.author,
      'chapterId': instance.chapterId,
      'chapterName': instance.chapterName,
      'collect': instance.collect,
      'courseId': instance.courseId,
      'desc': instance.desc,
      'envelopePic': instance.envelopePic,
      'fresh': instance.fresh,
      'id': instance.id,
      'link': instance.link,
      'niceDate': instance.niceDate,
      'niceShareDate': instance.niceShareDate,
      'origin': instance.origin,
      'originId': instance.originId,
      'prefix': instance.prefix,
      'projectLink': instance.projectLink,
      'publishTime': instance.publishTime,
      'selfVisible': instance.selfVisible,
      'shareDate': instance.shareDate,
      'shareUser': instance.shareUser,
      'superChapterId': instance.superChapterId,
      'superChapterName': instance.superChapterName,
      'tags': instance.tags,
      'title': instance.title,
      'type': instance.type,
      'userId': instance.userId,
      'visible': instance.visible,
      'zan': instance.zan
    };
