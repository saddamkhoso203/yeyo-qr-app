import 'package:flutter/material.dart';
import 'package:yeyo_qr_app/Languages/translator.dart';

import '../theme/app_colors.dart';
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
      {"code": "fr", "label": t["lang_fr"] ?? "Français"},
    ];

    final isFrench = currentLangCode == 'fr';

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Header ──
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        isFrench ? 'Choisir la langue' : 'Select Language',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setLocale(context, Locale(currentLangCode));
                        Navigator.pop(context);
                      },
                      child: Text(
                        isFrench ? 'Terminé' : 'Done',
                        style: const TextStyle(
                          color: AppColors.green,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // ── Language list ──
              ListView(
                shrinkWrap: true,
                children: languages.map((lang) {
                  final isSelected = lang["code"] == currentLangCode;

                  return ListTile(
                    title: Text(
                      lang["label"]!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),

                    // ✅ Animated checkmark
                    trailing: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      transitionBuilder: (child, animation) {
                        final slide = Tween<Offset>(
                          begin: const Offset(0.3, 0),
                          end: Offset.zero,
                        ).animate(animation);

                        return SlideTransition(
                          position: slide,
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              key: ValueKey('check'),
                              color: AppColors.green,
                            )
                          : const SizedBox(key: ValueKey('empty'), width: 24),
                    ),

                    onTap: () {
                      setState(() {
                        currentLangCode = lang["code"]!;
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
