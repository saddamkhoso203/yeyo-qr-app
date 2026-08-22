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
                  Text(t['privacy_intro_title']!, style: AppTextStyle.heading),
                  const SizedBox(height: 8),
                  Text(t['privacy_intro_text']!, style: AppTextStyle.body),
                  const SizedBox(height: 16),
                  Text(t['data_disclaimer']!, style: AppTextStyle.heading),
                  const SizedBox(height: 8),
                  Text(t['data_disclaimer_text']!, style: AppTextStyle.body),
                  const SizedBox(height: 16),
                  Text(t['changes_policy']!, style: AppTextStyle.heading),
                  const SizedBox(height: 8),
                  Text(t['changes_policy_text']!, style: AppTextStyle.body),
                  const SizedBox(height: 16),
                  Text(
                    t['license_and_copyright']!,
                    style: AppTextStyle.heading,
                  ),
                  const SizedBox(height: 8),
                  Text(t['license_text']!, style: AppTextStyle.body),
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
