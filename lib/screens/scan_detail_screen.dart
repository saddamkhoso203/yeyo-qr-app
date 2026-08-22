import 'package:flutter/material.dart';

import '../data/driver_model.dart';
import '../data/driver_repository.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_style.dart';
import '../Languages/translator.dart';

class ScanDetailScreen extends StatelessWidget {
  final String scannedId;

  const ScanDetailScreen({super.key, required this.scannedId});

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final t = T.get(context);

    return FutureBuilder<Driver?>(
      future: DriverRepository.instance.getDriverByBadge(scannedId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text(t["driver_details"] ?? "Driver Details"),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  snapshot.error.toString(),
                  textAlign: TextAlign.center,
                  style: AppTextStyle.body,
                ),
              ),
            ),
          );
        }

        final Driver? driver = snapshot.data;

        if (driver == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text(t["driver_details"] ?? "Driver Details"),
            ),
            body: Center(
              child: Text(
                t["no_driver_info"] ?? "No driver information found",
                style: AppTextStyle.body,
              ),
            ),
          );
        }

        final bool isApproved = driver.status.toLowerCase() == 'approved';

        return Scaffold(
          backgroundColor: AppColors.lightBackground,

          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              t["driver_details"] ?? "Driver Details",
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 18,
                color: AppColors.textPrimary,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              children: [
                _buildStatusBanner(context, driver, isApproved),

                const SizedBox(height: 14),

                _buildDriverMainCard(context, driver, isApproved),
              ],
            ),
          ),
        );
      },
    );
  }

  // STATUS BANNER
  Widget _buildStatusBanner(
    BuildContext context,
    Driver driver,
    bool isApproved,
  ) {
    final t = T.get(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isApproved
            ? AppColors.green.withOpacity(0.08)
            : Colors.red.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            isApproved ? Icons.check_circle : Icons.error,
            color: isApproved ? AppColors.green : Colors.red,
            size: 18,
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              isApproved
                  ? (t["approved_banner"] ??
                        "This driver has been approved by Yeyo")
                  : (t["not_approved"] ??
                        "This driver is NOT approved by Yeyo"),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // DRIVER MAIN CARD
  Widget _buildDriverMainCard(
    BuildContext context,
    Driver driver,
    bool isApproved,
  ) {
    final t = T.get(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // HEADER
          Container(
            height: 86,
            decoration: const BoxDecoration(
              color: Color(0xFF102437),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
          ),

          // PROFILE PHOTO
          Transform.translate(
            offset: const Offset(0, -42),
            child: Container(
              width: 92,
              height: 92,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _buildDriverPhoto(driver),
              ),
            ),
          ),

          const SizedBox(height: 6),

          // NAME + VERIFIED
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    driver.name.isNotEmpty
                        ? driver.name
                        : (t["unknown_driver"] ?? "Unknown Driver"),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),

                const SizedBox(width: 4),

                Icon(
                  driver.isVerified ? Icons.verified : Icons.info_outline,
                  color: driver.isVerified ? AppColors.green : Colors.orange,
                  size: 18,
                ),
              ],
            ),
          ),

          const SizedBox(height: 4),

          // STATUS
          Text(
            driver.status.isNotEmpty
                ? driver.status.toUpperCase()
                : (isApproved ? "APPROVED" : "NOT APPROVED"),
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 20),

          // DRIVER INFORMATION
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _field(t["driver_id"] ?? "Driver ID", driver.driverCode),

                const SizedBox(height: 12),

                _field(
                  t["date_of_birth"] ?? "Date of Birth",
                  _formatDate(driver.dateOfBirth),
                ),

                const SizedBox(height: 12),

                _field(
                  t["renewal_date"] ?? "Renewal Date",
                  _formatDate(driver.idRenewalDate),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // VERIFICATION STATUS
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: driver.isVerified
                  ? AppColors.green.withOpacity(0.08)
                  : Colors.orange.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  driver.isVerified
                      ? Icons.verified_user
                      : Icons.warning_amber_rounded,
                  color: driver.isVerified ? AppColors.green : Colors.orange,
                  size: 18,
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    driver.isVerified
                        ? (t["verified_driver"] ?? "Verified Driver")
                        : (t["driver_not_verified"] ?? "Driver Not Verified"),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // DRIVER PHOTO
  Widget _buildDriverPhoto(Driver driver) {
    final photoUrl = driver.photoUrl;

    // API returned photo_url: null
    if (photoUrl == null || photoUrl.trim().isEmpty) {
      return _defaultDriverPhoto();
    }

    // Remote image
    if (photoUrl.startsWith('http://') || photoUrl.startsWith('https://')) {
      return Image.network(
        photoUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return _defaultDriverPhoto();
        },
      );
    }

    // Local asset
    return Image.asset(
      photoUrl,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return _defaultDriverPhoto();
      },
    );
  }

  Widget _defaultDriverPhoto() {
    return Container(
      color: AppColors.lightBackground,
      child: const Center(
        child: Icon(Icons.person, size: 48, color: AppColors.textSecondary),
      ),
    );
  }

  // FIELD
  Widget _field(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),

        const SizedBox(height: 6),

        Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          alignment: Alignment.centerLeft,
          child: Text(
            value.isNotEmpty ? value : 'N/A',
            style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}
