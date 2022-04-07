import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simpsons_character_viewer/modules/splash/splash_screen.dart';
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

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
      home: SplashScreen(),
    );
  }
}
