import 'dart:convert';

import 'package:simpsons_character_viewer/data_models/data/character_details.dart';

class CharacterListResponse {
  CharacterListResponse({
    this.characters = const [],
  });

  final List<CharacterDetailsModel> characters;

  CharacterListResponse copyWith({
    List<CharacterDetailsModel>? characters,
  }) =>
      CharacterListResponse(
        characters: characters ?? this.characters,
      );

  factory CharacterListResponse.fromJson(String str) =>
      CharacterListResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CharacterListResponse.fromMap(Map<String, dynamic> json) =>
      CharacterListResponse(
        characters: json["RelatedTopics"] == null
            ? []
            : List<CharacterDetailsModel>.from(json["RelatedTopics"]
                .map((x) => CharacterDetailsModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "RelatedTopics": characters.isEmpty
            ? null
            : List<dynamic>.from(characters.map((x) => x.toMap())),
      };
}
