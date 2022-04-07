import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:simpsons_character_viewer/modules/character_view/repo/character_view_repo.dart';

import '../constants/network.dart';
import '../services/dio/api_provider.dart';
import '../services/local_repo.dart';

Future<void> configureDependencies() async {
  //Setting Dio base options for all api calls with timeout options and base url.
  BaseOptions options = BaseOptions(
    receiveTimeout: NetworkConstants.receiveTimeout,
    connectTimeout: NetworkConstants.connectTimeout,
    baseUrl: NetworkConstants.devBaseURl,
  );

  //Lazily loading the providers for data handling
  GetIt.I.registerLazySingleton<CancelToken>(() => CancelToken());
  GetIt.I.registerLazySingleton<LocalRepository>(() => LocalRepository());
  GetIt.I.registerLazySingleton<Dio>(() => Dio(options));
  GetIt.I.registerLazySingleton<ApiProvider>(() => ApiProvider(
      dio: GetIt.I.get(),
      localRepository: GetIt.I.get(),
      cancelToken: GetIt.I.get()));
  GetIt.I.registerLazySingleton(() => CharacterViewRepo(
      apiProvider: GetIt.I.get(), localRepository: GetIt.I.get()));
}
