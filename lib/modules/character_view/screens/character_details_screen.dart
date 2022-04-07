import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simpsons_character_viewer/constants/enums.dart';
import 'package:simpsons_character_viewer/data_models/data/character_details.dart';
import 'package:simpsons_character_viewer/utils/check_device_type.dart';

import '../../../constants/strings.dart';
import '../../../utils/loading_indicator.dart';
import '../bloc/character_view_bloc.dart';

class CharacterDetailsScreen extends StatefulWidget {
  const CharacterDetailsScreen({Key? key}) : super(key: key);

  @override
  State<CharacterDetailsScreen> createState() => _CharacterDetailsScreenState();
}

class _CharacterDetailsScreenState extends State<CharacterDetailsScreen> {
  late final CharacterViewBloc _characterViewBloc =
      BlocProvider.of<CharacterViewBloc>(context);
  CharacterDetailsModel? _character;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getDeviceType(context) == DeviceType.mobile
          ? AppBar(
              title: Text(
                _character?.getCharacterName ?? AppConstants.appName,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
            )
          : null,
      body: Stack(
        children: [
          mainContent(),
          BlocConsumer<CharacterViewBloc, CharacterViewState>(
            bloc: _characterViewBloc,
            listener: (context, state) async {
              if (state is CharacterDetailsFetchSuccess) {
                setState(() {
                  _character = state.characterDetails;
                });
              } else if (state is CharacterViewFailed) {
                await ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(
                      behavior: SnackBarBehavior.fixed,
                      content: Text(
                        state.message,
                        textAlign: TextAlign.center,
                      ),
                      duration: const Duration(seconds: 2),
                    ))
                    .closed;
              }
            },
            builder: (context, state) => LoadingIndicator(
              visibility: (state is CharacterDataLoading),
            ),
          ),
        ],
      ),
    );
  }

  Widget mainContent() {
    if (_character == null) {
      return const Padding(
        padding: EdgeInsets.all(24.0),
        child: Center(
          child: Text(
            AppConstants.selectCharacter,
            maxLines: 3,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 32,
            ),
          ),
        ),
      );
    } else {
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_character?.getavatarUrl != null)
              CachedNetworkImage(
                height: 240,
                width: double.infinity,
                imageUrl: _character?.getavatarUrl ?? '',
                placeholder: (context, url) => const Icon(Icons.person),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                _character!.getCharacterName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                _character!.text ?? '',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
