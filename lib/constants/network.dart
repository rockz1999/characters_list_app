abstract class NetworkConstants {
  static const String authorization = 'Authorization';
  static const String apikey = 'ApiKey';
  static const String platformKey = 'device_platform';
  static const String platformIos = 'iOS';
  static const String platformAndroid = 'Android';
  static const String apiKeyValue = '';

  static const int statusCodeSuccess = 200;
  static const int statusCodeUnauthorized = 401;

  static const int receiveTimeout = 20000;
  static const int imageUploadTimeout = 200000;
  static const int connectTimeout = 20000;
  static const String devBaseURl = 'https://api.duckduckgo.com/';
  static const String simpsonUrl = devBaseURl + simpsonCharacterEndpoint;

  static const String wireUrl = devBaseURl + wireCharacterEndpoint;

  static const String simpsonCharacterEndpoint =
      '?q=simpsons+characters&format=json';

  static const String wireCharacterEndpoint =
      '?q=the+wire+characters&format=json';
}
