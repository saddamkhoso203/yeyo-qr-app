import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_style.dart';
import '../widgets/bottom_nav.dart';
import '../Languages/translator.dart';

class ScanQrScreen extends StatelessWidget {
  const ScanQrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = T.get(context);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),

            /// TRANSLATED TEXT
            Text(
              t["scan_instruction"] ??
                  'Position the code within the frame to scan',
              style: AppTextStyle.body.copyWith(color: Colors.white70),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            /// QR FRAME (tap to simulate)
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/approved'),
              onLongPress: () => Navigator.pushNamed(context, '/not-approved'),
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.green, width: 3),
                ),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.darkCard,
                      borderRadius: BorderRadius.circular(20),
                      image: const DecorationImage(
                        image: AssetImage('assets/qr_placeholder.png'),
                      ),
                    ),
                    child: Image.asset('assets/barcode.png'),
                  ),
                ),
              ),
            ),

            const Spacer(),

            const BottomNavBar(active: BottomTab.scan),
          ],
        ),
      ),
    );
  }
}
