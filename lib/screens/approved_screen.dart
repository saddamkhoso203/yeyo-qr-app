// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_style.dart';
import '../widgets/bottom_nav.dart';
import '../Languages/translator.dart';

class ApprovedScreen extends StatelessWidget {
  const ApprovedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = T.get(context);

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
          icon: const Icon(Icons.arrow_back_ios_new,
              size: 18, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
        child: Column(
          children: [
            _buildApprovedBanner(context),
            const SizedBox(height: 14),
            _buildDriverMainCard(context),
            const SizedBox(height: 18),
            _buildQrCard(context),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(active: BottomTab.scan),
    );
  }

  // 1) GREEN APPROVED BANNER ----------------------------------------------------

  Widget _buildApprovedBanner(BuildContext context) {
    final t = T.get(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.green.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.green, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              t["approved_banner"] ?? "This driver has been approved by Yeyo",
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

  // 2) FULL MAIN CARD -----------------------------------------------------------

  Widget _buildDriverMainCard(BuildContext context) {
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
                border: Border.all(color: Color(0xFFE4E5E7), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/profile.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          const SizedBox(height: 6),

          // NAME + VERIFIED
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Saddam Khoso',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(width: 4),
              Icon(Icons.verified, color: AppColors.green, size: 18),
            ],
          ),

          const SizedBox(height: 4),

          // SUBTITLE
          Text(
            t["chauffeur_partner"] ?? "Chauffeur Partenaire Yeyo",
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 20),

          // FIELDS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _field(context, t["driver_id"] ?? "Driver ID", "YY456862"),
                const SizedBox(height: 12),
                _field(context, t["date_of_birth"] ?? "Date of Birth", "15/03/1980"),
                const SizedBox(height: 12),
                _field(context, t["renewal_date"] ?? "ID Renewal Date", "28/02/2028"),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // VERIFIED DRIVER BAR
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.green.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified_user,
                    color: AppColors.green, size: 18),
                const SizedBox(width: 8),
                Text(
                  t["verified_driver"] ?? "Verified Driver",
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

  // FIELD WIDGET ----------------------------------------------------------------

  Widget _field(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
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
            value,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  // 3) QR CARD ------------------------------------------------------------------

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
            offset: Offset(0, 4),
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

          // GREEN BUTTON
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
              onPressed: () =>
                  Navigator.popUntil(context, ModalRoute.withName('/scan')),
              child: Text(t["scan_another"] ?? "Scan Another"),
            ),
          ),

          const SizedBox(height: 6),

          TextButton(
            onPressed: () =>
                Navigator.popUntil(context, ModalRoute.withName('/scan')),
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
