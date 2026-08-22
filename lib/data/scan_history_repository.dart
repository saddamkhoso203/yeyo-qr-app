class ScanHistoryItem {
  final String scannedId;
  final bool isApproved;
  final DateTime scannedAt;
  final String device;
  final String type;

  const ScanHistoryItem({
    required this.scannedId,
    required this.isApproved,
    required this.scannedAt,
    required this.device,
    this.type = 'qr',
  });
}

/// API-free history repository.
/// History APIs are intentionally NOT integrated yet. This temporary
/// in-memory store keeps the existing UI compiling while the requested
/// YeYo /scan and /drivers APIs are integrated first.
///
class ScanHistoryRepository {
  static final List<ScanHistoryItem> _history = [];

  static Future<void> saveScan({
    required String scannedId,
    required bool isApproved,
  }) async {
    _history.insert(
      0,
      ScanHistoryItem(
        scannedId: scannedId,
        isApproved: isApproved,
        scannedAt: DateTime.now(),
        device: 'mobile',
      ),
    );
  }

  static Stream<List<ScanHistoryItem>> getScanHistory() async* {
    yield List.unmodifiable(_history);
  }
}
