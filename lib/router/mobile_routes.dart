import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simpsons_character_viewer/modules/character_view/bloc/character_view_bloc.dart';
import 'package:simpsons_character_viewer/modules/character_view/character_view_base_screen.dart';
import 'package:simpsons_character_viewer/router/routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final _args = settings.arguments;

    switch (settings.name) {
      case Routes.characterView:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider<CharacterViewBloc>(
                create: (BuildContext context) => CharacterViewBloc(),
              ),
            ],
            child: const CharacterViewBaseScreen(),
          ),
        );

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() => MaterialPageRoute(builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Error'),
          ),
          body: const Center(
            child: Text('ERROR'),
          ),
        );
      });
}
