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

                  // HOW TO USE
                  Text(
                    t['how_to_use'] ?? 'How to use',
                    style: AppTextStyle.heading,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    t['how_to_use_desc'] ??
                        'Run the scanner, point at the code, not too close, so that there is empty space around the code. Do not scan diagonally.',
                    style: AppTextStyle.body,
                  ),

                  const SizedBox(height: 16),

                  // ISSUES + QUESTIONS
                  Text(
                    t['issues_questions'] ?? 'Issues and questions',
                    style: AppTextStyle.heading,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    t['contact_email'] ??
                        'Feel free to contact us if you have any problems or questions: support@yeyocar.com',
                    style: AppTextStyle.body,
                  ),

                  const SizedBox(height: 16),

                  // SCAN HINTS
                  Text(
                    t['scan_hints'] ?? 'Scan hints',
                    style: AppTextStyle.heading,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    t['scan_hints_desc'] ??
                        '',
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
