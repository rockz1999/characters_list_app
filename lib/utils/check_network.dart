import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> checkNetwork() async {
  bool isConnectionAvailable = false;
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    isConnectionAvailable = true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    isConnectionAvailable = true;
  }
  return isConnectionAvailable;
}
