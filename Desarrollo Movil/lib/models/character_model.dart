// To parse this JSON data, do
//
//     final characterModel = characterModelFromJson(jsonString);

import 'dart:convert';

CharacterModel characterModelFromJson(String str) =>
    CharacterModel.fromJson(json.decode(str));

String characterModelToJson(CharacterModel data) => json.encode(data.toJson());

class CharacterModel {
  CharacterModel({
    this.id,
    this.age,
    this.birthdate,
    this.description,
    this.firstAppearanceEpId,
    this.firstAppearanceShId,
    this.gender,
    this.name,
    this.occupation,
    this.phrases,
    this.portraitPath,
    this.status,
  });

  int? id;
  int? age;
  String? birthdate;
  String? description;
  int? firstAppearanceEpId;
  int? firstAppearanceShId;
  String? gender;
  String? name;
  String? occupation;
  List<String>? phrases;
  String? portraitPath;
  String? status;

  factory CharacterModel.fromJson(Map<String, dynamic> json) => CharacterModel(
        id: json["id"] is int ? json["id"] : (json["id"] != null ? int.tryParse(json["id"].toString()) : null),
        age: json["age"] is int ? json["age"] : (json["age"] != null ? int.tryParse(json["age"].toString()) : null),
        birthdate: json["birthdate"],
        description: json["description"],
        firstAppearanceEpId: json["first_appearance_ep_id"] is int
            ? json["first_appearance_ep_id"]
            : (json["first_appearance_ep_id"] != null ? int.tryParse(json["first_appearance_ep_id"].toString()) : null),
        firstAppearanceShId: json["first_appearance_sh_id"] is int
            ? json["first_appearance_sh_id"]
            : (json["first_appearance_sh_id"] != null ? int.tryParse(json["first_appearance_sh_id"].toString()) : null),
        gender: json["gender"],
        name: json["name"],
        occupation: json["occupation"],
        phrases: json["phrases"] == null ? null : List<String>.from(json["phrases"].map((x) => x.toString())),
        portraitPath: json["portrait_path"] ?? json["portraitPath"] ?? json["image"] ?? json["image_url"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "age": age,
        "birthdate": birthdate,
        "description": description,
        "first_appearance_ep_id": firstAppearanceEpId,
        "first_appearance_sh_id": firstAppearanceShId,
        "gender": gender,
        "name": name,
        "occupation": occupation,
        "phrases": phrases == null ? null : List<dynamic>.from(phrases!.map((x) => x)),
        "portrait_path": portraitPath,
        "status": status,
      };
}
