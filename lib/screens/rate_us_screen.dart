import 'package:flutter/material.dart';
import 'package:yeyo_qr_app/Languages/translator.dart';
import 'package:yeyo_qr_app/theme/app_text_style.dart';
import 'package:yeyo_qr_app/widgets/bottom_nav.dart';

class RateUsScreen extends StatelessWidget {
  const RateUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = T.get(context);
    return Scaffold(
      appBar: AppBar(title: Text(t['rate'] ?? 'Rate')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t['rate_title']!, style: AppTextStyle.heading),
                  const SizedBox(height: 12),
                  Text(t['rate_description']!, style: AppTextStyle.body),
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
