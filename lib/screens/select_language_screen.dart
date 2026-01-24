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
    currentLangCode = getCurrentLocale(context).languageCode;
  }

  @override
  Widget build(BuildContext context) {
    final t = T.get(context);

    final languages = [
      {"code": "en", "label": t["lang_en"] ?? "English"},
      {"code": "fr", "label": t["lang_fr"] ?? "French"},
    ];

    return Scaffold(
      backgroundColor: const Color(0xF0F5F5F5),
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: ListView(
            shrinkWrap: true,
            children: languages.map((lang) {
              final isSelected = lang["code"] == currentLangCode;

              return ListTile(
                title: Text(lang["label"]!, style: AppTextStyle.body),
                trailing: isSelected
                    ? const Icon(Icons.check, color: AppColors.green)
                    : null,
                onTap: () {
                  setLocale(context, Locale(lang["code"]!));
                  setState(() {
                    currentLangCode = lang["code"]!;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
