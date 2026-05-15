import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
    Future<bool> get isConnected;
    Stream<bool> get onStatusChange;
}

class NetworkInfoImpl implements NetworkInfo {
    final Connectivity connectivity;
    NetworkInfoImpl(this.connectivity);

    @override
    Future<bool> get isConnected async {
      final result = await connectivity.checkConnectivity();
      return _check(result);
    }

    @override
    Stream<bool> get onStatusChange =>
        connectivity.onConnectivityChanged.map(_check);

    bool _check(List<ConnectivityResult> results) {
      return results.any((result) => result != ConnectivityResult.none);
    }
}