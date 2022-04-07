import 'package:flutter/material.dart';
import 'package:simpsons_character_viewer/constants/enums.dart';
import 'package:simpsons_character_viewer/modules/character_view/screens/character_details.dart';
import 'package:simpsons_character_viewer/modules/character_view/screens/character_list_screen.dart';
import 'package:simpsons_character_viewer/utils/check_device_type.dart';

class CharacterViewBaseScreen extends StatefulWidget {
  const CharacterViewBaseScreen({Key? key}) : super(key: key);

  @override
  State<CharacterViewBaseScreen> createState() =>
      _CharacterViewBaseScreenState();
}

class _CharacterViewBaseScreenState extends State<CharacterViewBaseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: mainContent(),
    );
  }

  Widget mainContent() {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return const CharacterListScreen();
      case DeviceType.tablet:
        return tabletContent();
      default:
        return Container();
    }
  }

  Widget tabletContent() {
    return Row(
      children: const [
        Expanded(child: CharacterListScreen()),
        Expanded(child: CharacterDetailsScreen()),
      ],
    );
  }
}
