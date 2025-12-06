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
      appBar: AppBar(
        title: Text(t["about"] ?? "About"),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  /// Title
                  Text(
                    t["about_title"] ?? "QR-code scanner",
                    style: AppTextStyle.heading,
                  ),

                  const SizedBox(height: 12),

                  /// Description
                  Text(
                    t["about_description"] ??
                        "This application uses the camera of your device to read bar-codes and QR-codes. "
                            "Point the camera at the code and you will see an extra preview of the encoded data.",
                    style: AppTextStyle.body,
                  ),

                  const SizedBox(height: 16),

                  /// Supported formats title
                  Text(
                    t["supported_formats"] ?? "Supported formats",
                    style: AppTextStyle.heading,
                  ),

                  const SizedBox(height: 8),

                  /// Supported formats list
                  Text(
                    t["supported_formats_list"] ??
                        "EAN-13/UPC-A, UPC-E, EAN-8, Code 128, Code 39, Code 93, "
                            "Codabar, Interleaved 2 of 5, QR-Code and DataMatrix.",
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
