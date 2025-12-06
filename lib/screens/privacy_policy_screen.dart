import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import '../theme/app_text_style.dart';
import '../Languages/translator.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = T.get(context);

    return Scaffold(
      appBar: AppBar(title: Text(t['privacy_policy'] ?? 'Privacy Policy')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t['privacy_intro_title'] ??
                        'We do not collect any personal information',
                    style: AppTextStyle.heading,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    t['privacy_intro_text'] ??
                        'This application does not collect or transmit any user\'s personally identifiable information.',
                    style: AppTextStyle.body,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    t['data_disclaimer'] ?? 'Data Disclaimer',
                    style: AppTextStyle.heading,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    t['data_disclaimer_text'] ??
                        'This Privacy Statement does not apply to links you follow from this application to other sites...',
                    style: AppTextStyle.body,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    t['changes_policy'] ?? 'Changes to this Policy',
                    style: AppTextStyle.heading,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    t['changes_policy_text'] ??
                        'This policy may be revised at any time. By using our site or applications, you signify your acceptance of the revised policy.',
                    style: AppTextStyle.body,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    t['license_and_copyright'] ??
                        'License and Copyright',
                    style: AppTextStyle.heading,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    t['license_text'] ??
                        'This project is based on the zBar open source barcode scanning library, and is licensed to you under the terms of the YEYO TECH GENERAL PUBLIC LICENSE.',
                    style: AppTextStyle.body,
                  ),
                ],
              ),
            ),
          ),
          const BottomNavBar(active: BottomTab.more),
        ],
      ),
    );
  }
}
