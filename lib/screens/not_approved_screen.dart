import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_style.dart';
import '../Languages/translator.dart';

class NotApprovedScreen extends StatelessWidget {
  const NotApprovedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = T.get(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          t["driver_details"] ?? "Driver Details",
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 80),

          /// ❌ BIG RED CIRCLE ICON
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border, width: 3),
            ),
            child: const Center(
              child: Icon(Icons.close, size: 40, color: AppColors.textSecondary),
            ),
          ),

          const SizedBox(height: 24),

          /// ❌ NOT APPROVED MESSAGE
          Text(
            t["not_approved"] ?? "This driver is not approved by Yeyo",
            style: AppTextStyle.heading,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          /// 📄 NO INFO TEXT
          Text(
            t["no_driver_info"] ?? "No driver information found",
            style: AppTextStyle.body,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          /// GREEN BUTTON — Scan Another
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.green,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName('/scan'));
                },
                child: Text(
                  t["scan_another"] ?? "Scan Another",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
