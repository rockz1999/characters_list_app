import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simpsons_character_viewer/modules/character_view/bloc/character_view_bloc.dart';
import 'package:simpsons_character_viewer/modules/character_view/character_view_base_screen.dart';

import '../../constants/strings.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateToNextPage();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Text(
              AppConstants.appName,
              maxLines: 3,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 32,
              ),
            ),
          ),
        ),
      );

  void navigateToNextPage() =>
      Future.delayed(const Duration(seconds: 2), () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (context) => CharacterViewBloc(),
              child: const CharacterViewBaseScreen(),
            ),
          ),
        );
      });
}
