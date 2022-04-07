import 'package:simpsons_character_viewer/data_models/data/character_details.dart';
import 'package:simpsons_character_viewer/data_models/reponse/character_list_response.dart';

import '../../../constants/messages.dart';
import '../../../constants/network.dart';
import '../../../data_models/core/api_response.dart';
import '../../../services/dio/api_provider.dart';
import '../../../services/local_repo.dart';

class CharacterViewRepo {
  final ApiProvider apiProvider;
  final LocalRepository localRepository;
  List<CharacterDetailsModel> _characters = [];
  CharacterViewRepo({
    required this.apiProvider,
    required this.localRepository,
  });

  Future<ApiResponse> fetchCharacterList() async {
    try {
      ApiResponse? apiResponse = await apiProvider.performApi(
          url: NetworkConstants.simpsonCharacterEndpoint, authorize: false);

      if (apiResponse != null && apiResponse.isSuccess) {
        final characterRes = CharacterListResponse.fromJson(apiResponse.result);
        apiResponse.result = characterRes.characters;
        _characters = characterRes.characters;
        return apiResponse;
      } else {
        return ApiResponse(
            result: null,
            isSuccess: false,
            message: (apiResponse != null)
                ? apiResponse.message
                : Messages.apiUnhandledErrorMessage,
            statusCode: null);
      }
    } catch (e) {
      return ApiResponse(
          result: null,
          isSuccess: false,
          message: Messages.apiUnhandledErrorMessage,
          statusCode: null);
    }
  }

  Future<List<CharacterDetailsModel>> fetchFilteredList(String filter) async {
    final List<CharacterDetailsModel> filteredList = [];
    for (CharacterDetailsModel character in _characters) {
      if (character.text?.toLowerCase().contains(filter) ?? false) {
        filteredList.add(character);
      }
    }
    return filteredList;
  }
}
