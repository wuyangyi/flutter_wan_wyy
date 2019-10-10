import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  User();

  bool admin;

  List chapterTops;

  List collectIds;

  String email;

  String icon;

  num id;

  String nickname;

  String password;

  String publicName;

  String token;

  num type;

  String username;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
