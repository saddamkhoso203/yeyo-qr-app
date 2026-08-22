import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import '../theme/app_text_style.dart';
import '../Languages/translator.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = T.get(context);

    return Scaffold(
      appBar: AppBar(title: Text(t['help'] ?? 'Help')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t['how_to_use']!, style: AppTextStyle.heading),
                  const SizedBox(height: 8),
                  Text(t['how_to_use_desc']!, style: AppTextStyle.body),
                  const SizedBox(height: 20),
                  Text(t['issues_questions']!, style: AppTextStyle.heading),
                  const SizedBox(height: 8),
                  Text(t['contact_email']!, style: AppTextStyle.body),
                  const SizedBox(height: 20),
                  Text(t['scan_hints']!, style: AppTextStyle.heading),
                  const SizedBox(height: 8),
                  Text(t['scan_hints_desc']!, style: AppTextStyle.body),
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
