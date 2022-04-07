// To parse this JSON data, do
//
//     final characterDetailsModel = characterDetailsModelFromMap(jsonString);

import 'dart:convert';

class CharacterDetailsModel {
  CharacterDetailsModel({
    this.firstUrl,
    this.icon,
    this.result,
    this.text,
  });

  final String? firstUrl;
  final Icon? icon;
  final String? result;
  final String? text;

  CharacterDetailsModel copyWith({
    String? firstUrl,
    Icon? icon,
    String? result,
    String? text,
  }) =>
      CharacterDetailsModel(
        firstUrl: firstUrl ?? this.firstUrl,
        icon: icon ?? this.icon,
        result: result ?? this.result,
        text: text ?? this.text,
      );

  factory CharacterDetailsModel.fromJson(String str) =>
      CharacterDetailsModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CharacterDetailsModel.fromMap(Map<String, dynamic> json) =>
      CharacterDetailsModel(
        firstUrl: json["FirstURL"],
        icon: json["Icon"] == null ? null : Icon.fromMap(json["Icon"]),
        result: json["Result"],
        text: json["Text"],
      );

  Map<String, dynamic> toMap() => {
        "FirstURL": firstUrl,
        "Icon": icon?.toMap(),
        "Result": result,
        "Text": text,
      };
}

class Icon {
  Icon({
    this.height,
    this.url,
    this.width,
  });

  final String? height;
  final String? url;
  final String? width;

  Icon copyWith({
    String? height,
    String? url,
    String? width,
  }) =>
      Icon(
        height: height ?? this.height,
        url: url ?? this.url,
        width: width ?? this.width,
      );

  factory Icon.fromJson(String str) => Icon.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Icon.fromMap(Map<String, dynamic> json) => Icon(
        height: json["Height"],
        url: json["URL"],
        width: json["Width"],
      );

  Map<String, dynamic> toMap() => {
        "Height": height,
        "URL": url,
        "Width": width,
      };
}
