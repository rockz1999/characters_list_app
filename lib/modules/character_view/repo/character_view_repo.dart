import 'package:simpsons_character_viewer/data_models/reponse/character_list_response.dart';

import '../../../constants/messages.dart';
import '../../../constants/network.dart';
import '../../../data_models/core/api_response.dart';
import '../../../services/dio/api_provider.dart';
import '../../../services/local_repo.dart';

class CharacterViewRepo {
  final ApiProvider apiProvider;
  final LocalRepository localRepository;

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
}
