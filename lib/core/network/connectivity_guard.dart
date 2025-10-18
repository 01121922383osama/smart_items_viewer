import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../error/exceptions.dart';

class ConnectivityGuard {
  static final ConnectivityGuard _instance = ConnectivityGuard._internal();
  factory ConnectivityGuard() => _instance;
  ConnectivityGuard._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isConnected = true;

  bool get isConnected => _isConnected;

  Future<void> initialize() async {
    await _checkConnectivity();

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      _updateConnectivityStatus(results);
    });
  }

  Future<void> _checkConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _updateConnectivityStatus(results);
    } catch (e) {
      _isConnected = false;
    }
  }

  void _updateConnectivityStatus(List<ConnectivityResult> results) {
    _isConnected = results.any(
      (result) =>
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet,
    );
  }

  Future<void> ensureConnectivity() async {
    if (!_isConnected) {
      throw const ConnectivityException(
        message: 'No internet connection available',
        code: 'NO_CONNECTIVITY',
      );
    }
  }

  void dispose() {
    _connectivitySubscription?.cancel();
  }
}
