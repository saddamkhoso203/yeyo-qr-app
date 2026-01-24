// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../data/driver_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_style.dart';
import '../widgets/bottom_nav.dart';
import '../Languages/translator.dart';

class NotApprovedScreen extends StatelessWidget {
  const NotApprovedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = T.get(context);

    // If driver is NOT found in Firestore → driver == null
    final Driver? driver =
        ModalRoute.of(context)!.settings.arguments as Driver?;

    final bool notFound = driver == null;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          notFound
              ? (t["no_driver_info"] ?? "No driver information found")
              : (t["not_approved"] ?? "Driver Not Approved"),
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
            _buildWarningBanner(context, notFound, t.map),
            const SizedBox(height: 18),

            /// If driver data exists → show the card
            if (!notFound) _buildDriverCard(context, driver!, t.map),

            const SizedBox(height: 40),

            Text(
              t["close"] ?? "Close",
              style: AppTextStyle.body.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),

      bottomNavigationBar: const BottomNavBar(active: BottomTab.scan),
    );
  }

  // WARNING BANNER -------------------------------------------------------------
  Widget _buildWarningBanner(
    BuildContext context,
    bool notFound,
    Map<String, String> t,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.error, color: Colors.red, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              notFound
                  ? (t["no_driver_info"] ?? "No driver information found")
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

  // DRIVER CARD ----------------------------------------------------------------
  Widget _buildDriverCard(
    BuildContext context,
    Driver driver,
    Map<String, String> t,
  ) {
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
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(driver.photoUrl, fit: BoxFit.cover),
              ),
            ),
          ),

          const SizedBox(height: 6),

          // NAME
          Text(
            driver.fullName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            driver.role,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _field(context, t["driver_id"] ?? "Driver ID", driver.driverId),
                const SizedBox(height: 12),
                _field(
                  context,
                  t["date_of_birth"] ?? "Date of Birth",
                  driver.dateOfBirth,
                ),
                const SizedBox(height: 12),
                _field(
                  context,
                  t["renewal_date"] ?? "Renewal Date",
                  driver.renewalDate,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // FIELD UI -------------------------------------------------------------------
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
            value,
            style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}
