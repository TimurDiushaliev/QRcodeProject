// To parse this JSON data, do
//
//     final infoModel = infoModelFromJson(jsonString);

import 'dart:convert';

List<InfoModel> infoModelFromJson(String str) => List<InfoModel>.from(json.decode(str).map((x) => InfoModel.fromJson(x)));

String infoModelToJson(List<InfoModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class InfoModel {
    InfoModel({
        this.id,
        this.profile,
        this.incoming,
        this.outcoming,
        this.date,
    });

    int id;
    Profile profile;
    DateTime incoming;
    var outcoming;
    DateTime date;

    factory InfoModel.fromJson(Map<String, dynamic> json) => InfoModel(
        id: json["id"],
        profile: Profile.fromJson(json["profile"]),
        incoming: DateTime.parse(json["incoming"]).toLocal(),
        outcoming: (json['outcoming'] != null) ? DateTime.parse(json["outcoming"]).toLocal() : '',
        date: DateTime.parse(json["date"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "profile": profile.toJson(),
        "incoming": incoming.toIso8601String(),
        "outcoming": outcoming.toIso8601String(),
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    };
}

class Profile {
    Profile({
        this.id,
        this.user,
        this.position,
        this.subscription,
        this.company,
    });

    int id;
    User user;
    String position;
    dynamic subscription;
    int company;

    factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json["id"],
        user: User.fromJson(json["user"]),
        position: json["position"],
        subscription: json["subscription"],
        company: json["company"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user": user.toJson(),
        "position": position,
        "subscription": subscription,
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