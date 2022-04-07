import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:simpsons_character_viewer/data_models/data/character_details.dart';
import 'package:simpsons_character_viewer/modules/character_view/repo/character_view_repo.dart';

import '../../../data_models/core/api_response.dart';
part 'character_view_event.dart';
part 'character_view_state.dart';

class CharacterViewBloc extends Bloc<CharacterViewEvent, CharacterViewState> {
  late final CharacterViewRepo _characterViewRepository = GetIt.I.get();

  CharacterViewBloc() : super(CharacterViewInitial()) {
    on<FetchCharacterList>(_fetchCharacterList);
    on<FetchCharacterDetails>(_fetchCharacterDetails);
    on<FetchFilteredCharacters>(_fetchFilteredCharacter);
  }

  FutureOr<void> _fetchCharacterList(
      FetchCharacterList event, Emitter<CharacterViewState> emit) async {
    emit(CharacterDataLoading());
    ApiResponse apiResponse =
        await _characterViewRepository.fetchCharacterList();
    if (apiResponse.isSuccess) {
      //Success
      List<CharacterDetailsModel> characters = apiResponse.result;
      emit(
        CharacterListFetchSuccess(characters),
      );
    } else {
      //Failure
      emit(
        CharacterViewFailed(message: apiResponse.message.toString()),
      );
    }
  }

  FutureOr<void> _fetchCharacterDetails(
      FetchCharacterDetails event, Emitter<CharacterViewState> emit) async {
    emit(
      CharacterDetailsFetchSuccess(event.characterDetails),
    );
  }

  FutureOr<void> _fetchFilteredCharacter(
      FetchFilteredCharacters event, Emitter<CharacterViewState> emit) async {
    final _filteredList =
        await _characterViewRepository.fetchFilteredList(event.filter);
    emit(
      CharacterListFetchSuccess(_filteredList),
    );
  }
}
