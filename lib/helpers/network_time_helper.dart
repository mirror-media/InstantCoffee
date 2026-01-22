import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/widgets/logger.dart';

class NetworkTimeHelper with Logger {
  static final NetworkTimeHelper _instance = NetworkTimeHelper._internal();

  NetworkTimeHelper._internal();

  factory NetworkTimeHelper() => _instance;

  DateTime? _cachedNetworkUtc;
  DateTime? _cachedAt;

  Future<DateTime?> fetchNetworkUtcNow(
      {Duration maxAge = const Duration(minutes: 1)}) async {
    final DateTime now = DateTime.now();
    if (_cachedNetworkUtc != null &&
        _cachedAt != null &&
        now.difference(_cachedAt!) < maxAge) {
      return _cachedNetworkUtc;
    }

    final Uri uri = Uri.parse(Environment().config.mirrorMediaDomain);
    final DateTime? networkUtc = await _fetchUtcFromServer(uri);
    if (networkUtc != null) {
      _cachedNetworkUtc = networkUtc;
      _cachedAt = now;
    }
    return networkUtc;
  }

  Future<DateTime?> _fetchUtcFromServer(Uri uri) async {
    try {
      final response = await http.head(uri).timeout(const Duration(seconds: 8));
      final dateHeader = response.headers['date'];
      if (dateHeader != null) {
        return HttpDate.parse(dateHeader).toUtc();
      }
    } catch (e) {
      debugLog('Network time (HEAD) failed: $e');
    }

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 8));
      final dateHeader = response.headers['date'];
      if (dateHeader != null) {
        return HttpDate.parse(dateHeader).toUtc();
      }
    } catch (e) {
      debugLog('Network time (GET) failed: $e');
    }

    return null;
  }
}
