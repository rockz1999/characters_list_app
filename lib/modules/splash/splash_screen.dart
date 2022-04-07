import 'package:flutter/material.dart';

import '../../constants/strings.dart';
import '../../router/routes.dart';

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
  Widget build(BuildContext context) => const Scaffold(
        body: Padding(
          padding: EdgeInsets.all(24.0),
          child: Center(
            child: Text(
              AppConstants.appName,
              maxLines: 3,
              style: TextStyle(
                color: Colors.black,
                fontSize: 32,
              ),
            ),
          ),
        ),
      );

  void navigateToNextPage() =>
      Future.delayed(const Duration(seconds: 2), () async {
        Navigator.pushReplacementNamed(context, Routes.characterView);
      });
}
