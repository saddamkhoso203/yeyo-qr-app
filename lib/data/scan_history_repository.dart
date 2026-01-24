import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class ScanHistoryRepository {
  static final _db = FirebaseFirestore.instance;

  static Future<void> saveScan({
    required String scannedId,
    required bool isApproved,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final saveHistory = prefs.getBool('history') ?? true;

    if (!saveHistory) return;

    await _db.collection('scan_history').add({
      'scannedId': scannedId,
      'driverId': scannedId,
      'isApproved': isApproved,
      'scannedAt': FieldValue.serverTimestamp(),
      'device': Platform.isAndroid ? 'android' : 'ios',
    });
  }
}
