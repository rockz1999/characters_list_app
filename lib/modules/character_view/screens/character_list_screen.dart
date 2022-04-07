import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simpsons_character_viewer/constants/enums.dart';
import 'package:simpsons_character_viewer/data_models/data/character_details.dart';
import 'package:simpsons_character_viewer/modules/character_view/bloc/character_view_bloc.dart';
import 'package:simpsons_character_viewer/modules/character_view/widgets/character_name_list_widget.dart';
import 'package:simpsons_character_viewer/router/routes.dart';
import 'package:simpsons_character_viewer/utils/check_device_type.dart';

import '../../../utils/loading_indicator.dart';

class CharacterListScreen extends StatefulWidget {
  const CharacterListScreen({Key? key}) : super(key: key);

  @override
  State<CharacterListScreen> createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  List<CharacterDetailsModel> _characters = [];
  late final CharacterViewBloc _characterViewBloc =
      BlocProvider.of<CharacterViewBloc>(context);

  @override
  void initState() {
    super.initState();
    _characterViewBloc.add(FetchCharacterList());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[50],
      child: Stack(
        children: [
          ListView.separated(
              padding: const EdgeInsets.all(16),
              separatorBuilder: (context, index) => const SizedBox(
                    height: 10,
                  ),
              itemCount: _characters.length,
              itemBuilder: (context, index) => CharacterNameWidget(
                    name: _characters[index].getCharacterName,
                    avatarUrl: _characters[index].getavatarUrl,
                    onTap: () {
                      if (getDeviceType(context) == DeviceType.mobile) {
                        Navigator.of(context)
                            .pushNamed(Routes.characterDetails);
                      }
                      _characterViewBloc
                          .add(FetchCharacterDetails(_characters[index]));
                    },
                  )),
          BlocConsumer<CharacterViewBloc, CharacterViewState>(
            bloc: _characterViewBloc,
            listener: (context, state) async {
              if (state is CharacterListFetchSuccess) {
                setState(() {
                  _characters = state.characters;
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
}
