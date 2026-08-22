import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/driver_model.dart';

class ApiClient {
  static const String baseUrl = 'https://qrcode.yeyocar.com/api';

  Future<Driver> scanQrCode(String value) async {
    final response = await http.post(
      Uri.parse('$baseUrl/scan'),
      headers: const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'value': value,
        'code_type': 'qr_code',
      }),
    );

    final decoded = jsonDecode(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(decoded is Map && decoded['message'] != null
          ? decoded['message'].toString()
          : 'Unable to scan QR code');
    }

    if (decoded is! Map || decoded['success'] != true) {
      throw Exception(decoded is Map && decoded['message'] != null
          ? decoded['message'].toString()
          : 'Driver verification failed');
    }

    final data = decoded['data'];
    if (data is! Map || data['driver'] is! Map) {
      throw Exception('Invalid driver response from server');
    }

    return Driver.fromJson(Map<String, dynamic>.from(data['driver'] as Map));
  }

  Future<Driver> getDriverByCode(String driverCode) async {
    final response = await http.get(
      Uri.parse('$baseUrl/drivers/${Uri.encodeComponent(driverCode)}'),
      headers: const {'Accept': 'application/json'},
    );

    final decoded = jsonDecode(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(decoded is Map && decoded['message'] != null
          ? decoded['message'].toString()
          : 'Unable to load driver');
    }

    final data = decoded is Map ? decoded['data'] : null;
    final driverJson = data is Map && data['driver'] is Map
        ? data['driver']
        : data;

    if (driverJson is! Map) {
      throw Exception('Invalid driver response from server');
    }

    return Driver.fromJson(Map<String, dynamic>.from(driverJson));
  }
}
