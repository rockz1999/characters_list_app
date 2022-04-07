import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simpsons_character_viewer/router/mobile_routes.dart';
import 'package:simpsons_character_viewer/router/routes.dart';
import 'package:simpsons_character_viewer/utils/configurations.dart';

import 'constants/strings.dart';
import 'utils/bloc_observer.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  BlocOverrides.runZoned(
    () {
      runApp(
        const MyApp(),
      );
    },
    blocObserver: AipBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
      ),
    );
    return const MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      initialRoute: Routes.initial,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
