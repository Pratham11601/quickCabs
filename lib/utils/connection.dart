import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

class Connection {
  static final Connectivity _connectivity = Connectivity();
  bool _hasInternet = false;

  set initValue(bool value) {
    _hasInternet = value;
  }

  bool get hasInternet => _hasInternet;

  // Listen to change in network
  Future<bool> _listenChangeConnectivity(List<ConnectivityResult> event) async {
    return _checkInternet(event);
  }

  // Check internet and convert
  static Future<bool> _checkInternet(List<ConnectivityResult> event) async {
    // if network is mobile or wifi
    bool anyNetwork = event.any((element) =>
        element == ConnectivityResult.mobile ||
        element == ConnectivityResult.wifi);
    if (anyNetwork) {
      InternetAddress internetAddress =
          (await InternetAddress.lookup('google.com')).first;
      anyNetwork = internetAddress.rawAddress.isNotEmpty;
    }
    return anyNetwork;
  }

  static Future<bool> checkInternet() async {
    return _checkInternet(await _connectivity.checkConnectivity());
  }

  // Connection stream
  Stream<bool> get onChangeConnectivity => _connectivity.onConnectivityChanged
      .asyncMap<bool>(_listenChangeConnectivity);
}
