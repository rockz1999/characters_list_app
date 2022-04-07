import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simpsons_character_viewer/constants/enums.dart';
import 'package:simpsons_character_viewer/data_models/data/character_details.dart';
import 'package:simpsons_character_viewer/modules/character_view/bloc/character_view_bloc.dart';
import 'package:simpsons_character_viewer/modules/character_view/screens/character_details_screen.dart';
import 'package:simpsons_character_viewer/modules/character_view/widgets/character_name_list_widget.dart';
import 'package:simpsons_character_viewer/utils/check_device_type.dart';

import '../../../constants/strings.dart';
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
  bool showNoData = false;
  final TextEditingController _controller = TextEditingController();
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
          Column(
            children: [
              _searchWidget(),
              Expanded(
                child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 10,
                        ),
                    itemCount: _characters.length,
                    itemBuilder: (context, index) => CharacterNameWidget(
                          name: _characters[index].getCharacterName,
                          avatarUrl: _characters[index].getavatarUrl,
                          onTap: () async {
                            if (getDeviceType(context) == DeviceType.mobile) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                      value: _characterViewBloc,
                                      child: const CharacterDetailsScreen()),
                                ),
                              );
                              await Future.delayed(
                                  const Duration(milliseconds: 200));
                            }
                            _characterViewBloc
                                .add(FetchCharacterDetails(_characters[index]));
                          },
                        )),
              ),
            ],
          ),
          if (showNoData)
            const Padding(
              padding: EdgeInsets.all(24.0),
              child: Center(
                child: Text(
                  AppConstants.noData,
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 32,
                  ),
                ),
              ),
            ),
          BlocConsumer<CharacterViewBloc, CharacterViewState>(
              bloc: _characterViewBloc,
              listener: (context, state) async {
                if (state is CharacterListFetchSuccess) {
                  setState(() {
                    _characters = state.characters;
                    showNoData = _characters.isEmpty;
                  });
                } else if (state is CharacterDataLoading) {
                  setState(() {
                    showNoData = false;
                  });
                } else if (state is CharacterViewFailed) {
                  setState(() {
                    showNoData = true;
                  });
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
              builder: (context, state) {
                return LoadingIndicator(
                  visibility: (state is CharacterDataLoading),
                );
              }),
        ],
      ),
    );
  }

  Widget _searchWidget() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
                hintText: 'Search ',
              ),
              onSubmitted: (_) => _search(),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          TextButton(
            onPressed: _search,
            child: Row(
              children: const [
                Icon(Icons.search),
                SizedBox(
                  width: 8,
                ),
                Text('Search')
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _search() {
    _characterViewBloc.add(FetchFilteredCharacters(_controller.text));
  }
}
