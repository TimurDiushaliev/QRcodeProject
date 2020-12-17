// To parse this JSON data, do
//
//     final ProfileModel = ProfileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) =>
    ProfileModel.fromJson(json.decode(str));

List<ProfileModel> profileModelFromJson2(String str) => List<ProfileModel>.from(
    json.decode(str).map((x) => ProfileModel.fromJson(x)));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  ProfileModel({
    this.id,
    this.user,
    this.position,
    this.company,
  });

  int id;
  User user;
  String position;
  int company;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        id: json["id"],
        user: User.fromJson(json["user"]),
        position: json["position"],
        company: json["company"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user.toJson(),
        "position": position,
        "company": company,
      };
}

class User {
  User({
    this.username,
    this.firstName,
    this.lastName,
  });

  String username;
  String firstName;
  String lastName;

  factory User.fromJson(Map<String, dynamic> json) => User(
        username: json["username"],
        firstName: json["first_name"],
        lastName: json["last_name"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "first_name": firstName,
        "last_name": lastName,
      };
}
