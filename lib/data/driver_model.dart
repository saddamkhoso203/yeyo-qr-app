class Driver {
  final int? id;
  final String driverCode;
  final String name;
  final String? photoUrl;
  final DateTime? dateOfBirth;
  final DateTime? idRenewalDate;
  final String status;
  final bool isVerified;
  final String? qrCodeValue;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Driver({
    this.id,
    required this.driverCode,
    required this.name,
    this.photoUrl,
    this.dateOfBirth,
    this.idRenewalDate,
    required this.status,
    required this.isVerified,
    this.qrCodeValue,
    this.createdAt,
    this.updatedAt,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic value) =>
        value == null ? null : DateTime.tryParse(value.toString());

    return Driver(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id'] ?? ''}'),
      driverCode: '${json['driver_code'] ?? ''}',
      name: '${json['name'] ?? ''}',
      photoUrl: json['photo_url']?.toString(),
      dateOfBirth: parseDate(json['date_of_birth']),
      idRenewalDate: parseDate(json['id_renewal_date']),
      status: '${json['status'] ?? ''}',
      isVerified: json['is_verified'] == true,
      qrCodeValue: json['qr_code_value']?.toString(),
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at']),
    );
  }
}
