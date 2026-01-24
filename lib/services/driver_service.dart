

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yeyo_qr_app/data/driver_model.dart';

class DriverService {
  final _drivers = FirebaseFirestore.instance.collection('drivers');

  /// Get driver by driverId in QR
  Future<Driver?> getDriverByDriverId(String driverId) async {
    final query = await _drivers
        .where('driverId', isEqualTo: driverId)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;

    final doc = query.docs.first;
    return Driver.fromMap(doc.id, doc.data());
  }

  /// For seeding / manual creation if you want to call from a button or test
  Future<void> addTestDriver() async {
    await _drivers.add({
      'driverId': 'YY456862',
      'fullName': 'Saddam Khoso',
      'dateOfBirth': '15/03/1980',
      'renewalDate': '28/02/2028',
      'role': 'Chauffeur Partenaire Yeyo',
      'photoUrl': '', // not used, we show local asset
      'isApproved': true,
    });
  }
}
