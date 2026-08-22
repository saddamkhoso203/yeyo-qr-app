import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import '../theme/app_text_style.dart';
import '../Languages/translator.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = T.get(context);

    return Scaffold(
      appBar: AppBar(title: Text(t['about'] ?? 'About')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t['about_title']!, style: AppTextStyle.heading),
                  const SizedBox(height: 12),
                  Text(t['about_description']!, style: AppTextStyle.body),
                  const SizedBox(height: 20),
                  Text(t['supported_formats']!, style: AppTextStyle.heading),
                  const SizedBox(height: 8),
                  Text(t['supported_formats_list']!, style: AppTextStyle.body),
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
