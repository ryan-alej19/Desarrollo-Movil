// To parse this JSON data, do
//
//     final characterModel = characterModelFromJson(jsonString);

import 'dart:convert';

CharacterModel characterModelFromJson(String str) =>
    CharacterModel.fromJson(json.decode(str));

String characterModelToJson(CharacterModel data) => json.encode(data.toJson());

class CharacterModel {
  CharacterModel({
    required this.id,
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

  int id;
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
    id: json["id"],
    age: json["age"] == null ? null : json["age"],
    birthdate: json["birthdate"],
    description: json["description"],
    firstAppearanceEpId: json["first_appearance_ep_id"] == null
        ? null
        : json["first_appearance_ep_id"],
    firstAppearanceShId: json["first_appearance_sh_id"] == null
        ? null
        : json["first_appearance_sh_id"],
    gender: json["gender"],
    name: json["name"],
    occupation: json["occupation"],
    phrases: json["phrases"] == null
        ? null
        : List<String>.from(json["phrases"].map((x) => x)),
    portraitPath: json["portrait_path"],
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
    "phrases": phrases == null
        ? null
        : List<dynamic>.from(phrases!.map((x) => x)),
    "portrait_path": portraitPath,
    "status": status,
  };
}
