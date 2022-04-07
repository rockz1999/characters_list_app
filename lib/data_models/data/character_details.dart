// To parse this JSON data, do
//
//     final characterDetailsModel = characterDetailsModelFromMap(jsonString);

import 'dart:convert';

import 'package:simpsons_character_viewer/constants/network.dart';

class CharacterDetailsModel {
  CharacterDetailsModel({
    this.firstUrl,
    this.icon,
    this.result,
    this.text,
  });

  final String? firstUrl;
  final CharacterIcon? icon;
  final String? result;
  final String? text;

  CharacterDetailsModel copyWith({
    String? firstUrl,
    CharacterIcon? icon,
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
        icon: json["Icon"] == null ? null : CharacterIcon.fromMap(json["Icon"]),
        result: json["Result"],
        text: json["Text"],
      );

  Map<String, dynamic> toMap() => {
        "FirstURL": firstUrl,
        "Icon": icon?.toMap(),
        "Result": result,
        "Text": text,
      };

  String get getCharacterName {
    return text?.split('-')[0] ?? '';
  }

  String? get getavatarUrl {
    if (icon?.url != null && icon!.url!.isNotEmpty) {
      return NetworkConstants.devBaseURl + icon!.url!;
    }
    return null;
  }
}

class CharacterIcon {
  CharacterIcon({
    this.height,
    this.url,
    this.width,
  });

  final String? height;
  final String? url;
  final String? width;

  CharacterIcon copyWith({
    String? height,
    String? url,
    String? width,
  }) =>
      CharacterIcon(
        height: height ?? this.height,
        url: url ?? this.url,
        width: width ?? this.width,
      );

  factory CharacterIcon.fromJson(String str) =>
      CharacterIcon.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CharacterIcon.fromMap(Map<String, dynamic> json) => CharacterIcon(
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
