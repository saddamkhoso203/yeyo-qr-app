import 'package:flutter/foundation.dart';
import '../services/api_client.dart';
import 'driver_model.dart';

class DriverRepository {
  DriverRepository._();

  static final DriverRepository instance = DriverRepository._();
  final ApiClient _api = ApiClient();

  Future<Driver?> getDriverByBadge(String badge) async {
    try {
      return await _api.scanQrCode(badge);
    } catch (e) {
      debugPrint('Driver scan failed: $e');
      return null;
    }
  }

  Future<Driver?> getDriverByCode(String driverCode) async {
    try {
      return await _api.getDriverByCode(driverCode);
    } catch (e) {
      debugPrint('Driver lookup failed: $e');
      return null;
    }
  }
}
