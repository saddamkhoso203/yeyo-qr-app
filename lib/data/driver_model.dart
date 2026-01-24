class Driver {
  final String id;          // Firestore doc id
  final String driverId;    // ID printed on badge / in QR
  final String fullName;
  final String dateOfBirth;
  final String renewalDate;
  final String role;        // e.g. "Chauffeur Partenaire Yeyo"
  final String photoUrl;    // optional (for now use local asset)
  final bool isApproved;

  Driver({
    required this.id,
    required this.driverId,
    required this.fullName,
    required this.dateOfBirth,
    required this.renewalDate,
    required this.role,
    required this.photoUrl,
    required this.isApproved,
  });

  factory Driver.fromMap(String id, Map<String, dynamic> data) {
    return Driver(
      id: id,
      driverId: (data['driverId'] ?? '') as String,
      fullName: (data['fullName'] ?? '') as String,
      dateOfBirth: (data['dateOfBirth'] ?? '') as String,
      renewalDate: (data['renewalDate'] ?? '') as String,
      role: (data['role'] ?? '') as String,
      photoUrl: (data['photoUrl'] ?? '') as String,
      isApproved: (data['isApproved'] ?? false) as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'driverId': driverId,
      'fullName': fullName,
      'dateOfBirth': dateOfBirth,
      'renewalDate': renewalDate,
      'role': role,
      'photoUrl': photoUrl,
      'isApproved': isApproved,
    };
  }
}
