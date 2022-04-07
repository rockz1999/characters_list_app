import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:simpsons_character_viewer/utils/bloc_observer.dart';

import 'constants/enums.dart';
import 'my_app.dart';
import 'utils/configurations.dart';

Future<void> mainCommon(Environment environment) async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfigurations().loadEnvironmentConfigurations(environment);
  BlocOverrides.runZoned(
    () {
      runApp(
        const MyApp(),
      );
    },
    blocObserver: AipBlocObserver(),
  );
}
