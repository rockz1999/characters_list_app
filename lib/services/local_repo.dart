import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class LocalRepository {
  late SharedPreferences _sharedPreferences;

  static const String kaccessToken = "accessToken";
  static const String kidToken = "idToken";
  static const String krefreshToken = "refreshToken";
  static const String kapiAccessToken = "apiAccessToken";
  static const String kisLoggedIn = "is_logged_in";
  static const String kdefaultLocale = "default_language";
  static const String kuserName = "user_name";
  static const String kuserPassword = "user_password";
  static const String krefreshTime = "time";

  Future<void> setLogInStatus(bool status) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    await _sharedPreferences.setBool(kisLoggedIn, status);
  }

  Future<bool> getLogInStatus() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.getBool(kisLoggedIn) ?? false;
  }

  Future<void> setRestApiAccessToken(String? apiAccessToken) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    await _sharedPreferences.setString(kapiAccessToken, apiAccessToken ?? "");
  }

  Future<String> getRestApiAccessToken() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.getString(kapiAccessToken) ?? "";
  }

  Future<void> setAccessToken(String? accessToken) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    await _sharedPreferences.setString(kaccessToken, accessToken ?? "");
  }

  Future<String> getAccessToken() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.getString(kaccessToken) ?? "";
  }

  Future<void> setIdToken(String? idToken) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    await _sharedPreferences.setString(kidToken, idToken ?? "");
  }

  Future<String> getIdToken() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.getString(kidToken) ?? "";
  }

  Future<void> setRefreshToken(String? refreshToken) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    await _sharedPreferences.setString(krefreshToken, refreshToken ?? "");
  }

  Future<String> getRefreshToken() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.getString(krefreshToken) ?? "";
  }

  Future<void> setUserName(String userName) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    await _sharedPreferences.setString(kuserName, userName);
  }

  Future<String> getUserName() async {
    return _sharedPreferences.getString(kuserName) ?? "";
  }

  Future<void> setRefreshTime(DateTime dateTime) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    unawaited(
        _sharedPreferences.setString(krefreshTime, dateTime.toIso8601String()));
    return;
  }

  Future<DateTime> getRefreshTime() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    String date = _sharedPreferences.getString(krefreshTime) ?? "";
    if (date == "") {
      date = DateTime.now().toIso8601String();
      setRefreshTime(DateTime.now());
    }
    return DateTime.parse(date);
  }

  void clear() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.clear();
  }
}
