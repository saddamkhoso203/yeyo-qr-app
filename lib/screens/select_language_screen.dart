import 'package:flutter/material.dart';
import 'package:yeyo_qr_app/Languages/translator.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_style.dart';
import '../main.dart';

class SelectLanguageScreen extends StatefulWidget {
  const SelectLanguageScreen({super.key});

  @override
  State<SelectLanguageScreen> createState() => _SelectLanguageScreenState();
}

class _SelectLanguageScreenState extends State<SelectLanguageScreen> {
  late String currentLangCode;

  @override
  void initState() {
    super.initState();
    final locale = getCurrentLocale(context);
    currentLangCode = locale.languageCode; // "en" or "fr"
  }

  @override
  Widget build(BuildContext context) {
    final t = T.get(context);

    /// Dynamic translated language names
    final languages = [
      {"code": "en", "label": t["lang_en"] ?? "English"},
      {"code": "fr", "label": t["lang_fr"] ?? "French"},
    ];

    return Scaffold(
      backgroundColor: const Color(0xF0F5F5F5),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.pop(context),

        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
            ),
            padding: const EdgeInsets.only(top: 12, bottom: 20),

            child: GestureDetector(
              onTap: () {},

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // drag handle
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Row(
                      children: [
                        Text(
                          t['select_language'] ?? 'Select Language',
                          style: AppTextStyle.heading,
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text(
                            t['done'] ?? 'Done',
                            style: const TextStyle(
                              color: AppColors.green,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),
                  Divider(height: 1, color: Colors.grey.shade200),

                  // language list
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: languages.length,
                    itemBuilder: (_, i) {
                      final lang = languages[i];
                      final isSelected = lang["code"] == currentLangCode;

                      return Container(
                        color: isSelected
                            ? AppColors.green.withOpacity(0.08)
                            : Colors.white,
                        child: ListTile(
                          title: Text(
                            lang["label"]!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: isSelected
                              ? const Icon(Icons.check, color: AppColors.green)
                              : null,

                          onTap: () {
                            setLocale(
                              context,
                              Locale(lang["code"]!),
                            );

                            setState(() => currentLangCode = lang["code"]!);

                            Future.microtask(() {
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              }
                            });
                          },
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
