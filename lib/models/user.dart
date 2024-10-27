import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  int? id;
  final String username;
  final String email;
  final String? password;

  User({
    this.id,
    required this.username,
    required this.email,
    this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
