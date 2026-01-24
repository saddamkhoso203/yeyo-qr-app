import 'package:cloud_firestore/cloud_firestore.dart';
import 'driver_model.dart';

class DriverRepository {
  static final _collection =
      FirebaseFirestore.instance.collection('drivers');

  /// 🔥 Firestore lookup
  static Future<Driver?> getDriverByBadge(String badgeId) async {
    try {
      final snap = await _collection.doc(badgeId).get();

      if (!snap.exists) return null;

      return Driver.fromMap(snap.id, snap.data()!);
    } catch (e) {
      print("🔥 Firestore error: $e");
      return null;
    }
  }

  /// 🔥 OPTIONAL: fallback local lookup
  /// If no local list, simply return null
  static Driver? getDriver(String scannedId) {
    return null; // no offline data now
  }
}
