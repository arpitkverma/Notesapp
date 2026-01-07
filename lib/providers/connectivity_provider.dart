import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

class ConnectivityProvider extends ChangeNotifier {
  bool _hasInternet = true;
  bool get hasInternet => _hasInternet;
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  ConnectivityProvider() {
    _init();
  }

  GlobalKey<ScaffoldMessengerState> get scaffoldKey => _scaffoldKey;

  Future<void> _init() async {
    final results = await Connectivity().checkConnectivity();
    final wasOffline = !_hasInternet;
    _hasInternet = await _hasInternetAvailable(results);
    notifyListeners();

    _subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) async {
      final wasConnected = _hasInternet;
      final connected = await _hasInternetAvailable(results);

      if (connected != _hasInternet) {
        _hasInternet = connected;
        notifyListeners();
      }
    });
  }

  Future<bool> _hasInternetAvailable(List<ConnectivityResult> results) async {
    return results.isNotEmpty && results.any((r) => r != ConnectivityResult.none);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
