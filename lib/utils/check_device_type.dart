import 'package:flutter/material.dart';
import 'package:simpsons_character_viewer/constants/enums.dart';

DeviceType getDeviceType(BuildContext context) {
  final data = MediaQuery.of(context);
  return data.size.shortestSide < 600 ? DeviceType.mobile : DeviceType.tablet;
}
