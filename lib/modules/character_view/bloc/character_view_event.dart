part of 'character_view_bloc.dart';

@immutable
abstract class CharacterViewEvent {}

class FetchCharacterList extends CharacterViewEvent {}

class FetchCharacterDetails extends CharacterViewEvent {
  final CharacterDetailsModel characterDetails;

  FetchCharacterDetails(this.characterDetails);
}

class FetchFilteredCharacters extends CharacterViewEvent {}
