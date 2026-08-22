import 'package:yeyo_qr_app/data/driver_model.dart';
import 'package:yeyo_qr_app/data/driver_repository.dart';

/// Driver service.
///
/// Firebase/Firestore has been removed.
/// Driver data is now retrieved from the YeYo API.
class DriverService {
  final DriverRepository _repository = DriverRepository.instance;

  /// Scans/verifies a QR code through the YeYo API.
  ///
  /// The scanned QR value is sent to:
  /// POST /api/scan
  Future<Driver?> getDriverByDriverId(String driverId) {
    return _repository.getDriverByBadge(driverId);
  }

  /// Test-driver creation is no longer required.
  ///
  /// Drivers are retrieved from the YeYo API instead of Firestore.
  Future<void> addTestDriver() async {
    // No longer used.
  }
}
