// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../data/driver_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_style.dart';
import '../widgets/bottom_nav.dart';
import '../Languages/translator.dart';

class ApprovedScreen extends StatelessWidget {
  const ApprovedScreen({super.key});

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final t = T.get(context);

    final arguments = ModalRoute.of(context)?.settings.arguments;

    if (arguments is! Driver) {
      return Scaffold(
        backgroundColor: AppColors.lightBackground,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(t["driver_details"] ?? "Driver Details"),
        ),
        body: Center(
          child: Text(
            t["driver_not_found"] ?? "Driver information not found",
            style: AppTextStyle.body,
          ),
        ),
      );
    }

    final Driver driver = arguments;

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
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
        child: Column(
          children: [
            _buildApprovedBanner(context, driver),
            const SizedBox(height: 14),
            _buildDriverMainCard(context, driver),
            const SizedBox(height: 18),
            _buildQrCard(context),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(active: BottomTab.scan),
    );
  }

  // APPROVED BANNER
  Widget _buildApprovedBanner(BuildContext context, Driver driver) {
    final t = T.get(context);

    final isApproved =
        driver.status.toLowerCase() == 'approved' && driver.isVerified;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isApproved
            ? AppColors.green.withOpacity(0.08)
            : Colors.orange.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            isApproved ? Icons.check_circle : Icons.warning_rounded,
            color: isApproved ? AppColors.green : Colors.orange,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              isApproved
                  ? (t["approved_banner"] ??
                        "This driver has been approved by Yeyo")
                  : (t["driver_not_verified"] ?? "This driver is not verified"),
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
  Widget _buildDriverMainCard(BuildContext context, Driver driver) {
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
          Container(
            height: 86,
            decoration: const BoxDecoration(
              color: Color(0xFF102437),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
          ),

          // PROFILE PIC
          Transform.translate(
            offset: const Offset(0, -42),
            child: Container(
              width: 92,
              height: 92,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE4E5E7), width: 1),
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
          Row(
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

          const SizedBox(height: 4),

          // ROLE / DRIVER STATUS
          Text(
            driver.status.isNotEmpty
                ? driver.status.toUpperCase()
                : (t["chauffeur_partner"] ?? "Chauffeur Partenaire Yeyo"),
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 20),

          // DRIVER FIELDS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _field(
                  context,
                  t["driver_id"] ?? "Driver ID",
                  driver.driverCode,
                ),

                const SizedBox(height: 12),

                _field(
                  context,
                  t["date_of_birth"] ?? "Date of Birth",
                  _formatDate(driver.dateOfBirth),
                ),

                const SizedBox(height: 12),

                _field(
                  context,
                  t["renewal_date"] ?? "Renewal Date",
                  _formatDate(driver.idRenewalDate),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // VERIFIED BAR
          Container(
            width: double.infinity,
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
                Text(
                  driver.isVerified
                      ? (t["verified_driver"] ?? "Verified Driver")
                      : (t["driver_not_verified"] ?? "Driver Not Verified"),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
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

    if (photoUrl == null || photoUrl.trim().isEmpty) {
      return Container(
        color: AppColors.lightBackground,
        child: const Center(
          child: Icon(Icons.person, size: 48, color: AppColors.textSecondary),
        ),
      );
    }

    if (photoUrl.startsWith('http://') || photoUrl.startsWith('https://')) {
      return Image.network(
        photoUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return Container(
            color: AppColors.lightBackground,
            child: const Center(
              child: Icon(
                Icons.person,
                size: 48,
                color: AppColors.textSecondary,
              ),
            ),
          );
        },
      );
    }

    return Image.asset(
      photoUrl,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return Container(
          color: AppColors.lightBackground,
          child: const Center(
            child: Icon(Icons.person, size: 48, color: AppColors.textSecondary),
          ),
        );
      },
    );
  }

  // FIELD WIDGET
  Widget _field(BuildContext context, String label, String value) {
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

  // QR CARD
  Widget _buildQrCard(BuildContext context) {
    final t = T.get(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
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
          Align(
            alignment: Alignment.center,
            child: Text(
              t["driver_qr_code"] ?? "Driver QR Code",
              style: AppTextStyle.heading,
            ),
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.lightBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(
              'assets/barcode.png',
              color: AppColors.darkCard,
              height: 100,
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(46),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/scan'));
              },
              child: Text(t["scan_another"] ?? "Scan Another"),
            ),
          ),

          const SizedBox(height: 6),

          TextButton(
            onPressed: () {
              Navigator.popUntil(context, ModalRoute.withName('/scan'));
            },
            child: Text(
              t["close"] ?? "Close",
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
