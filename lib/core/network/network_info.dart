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
  Stream<bool> get onStatusChange {
    bool? lastEmitted;

    return connectivity.onConnectivityChanged
        .map(_check)
    // This is a native stream deduplicator. It prevents identical values
    // from ever entering your pipeline back-to-back.
        .where((status) {
      if (lastEmitted == status) return false;
      lastEmitted = status;
      return true;
    });
  }

  bool _check(List<ConnectivityResult> results) {
    return results.any((result) => result != ConnectivityResult.none);
  }
}