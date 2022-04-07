part of 'character_view_bloc.dart';

@immutable
abstract class CharacterViewState {}

class CharacterViewInitial extends CharacterViewState {}

class CharacterDataLoading extends CharacterViewState {}

class CharacterDetailsLoading extends CharacterViewState {}

class CharacterListFetchSuccess extends CharacterViewState {
  final List<CharacterDetailsModel> characters;

  CharacterListFetchSuccess(this.characters);
}

class CharacterDetailsFetchSuccess extends CharacterViewState {
  final CharacterDetailsModel characterDetails;

  CharacterDetailsFetchSuccess(this.characterDetails);
}

class CharacterFilteredFetchSuccess extends CharacterViewState {}

class CharacterViewFailed extends CharacterViewState {
  final String message;

  CharacterViewFailed({required this.message});
}
