import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import '../theme/app_colors.dart';
import '../Languages/translator.dart';
import '../main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool vibrate = true;
  bool beep = false;
  bool history = true;

  @override
  Widget build(BuildContext context) {
    final t = T.get(context);

    // Get locale
    final currentLocale = getCurrentLocale(context);
    final String langCode = currentLocale.languageCode;

    // ⭐ FIX → show correct translated label
    final currentLang = langCode == 'fr'
        ? (t['lang_fr'] ?? 'Français')
        : (t['lang_en'] ?? 'English');

    return Scaffold(
      appBar: AppBar(
        title: Text(t['settings'] ?? 'Settings'),
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                const SizedBox(height: 8),

                // LANGUAGE
                _cell(
                  child: ListTile(
                    title: Text(t['language'] ?? 'Langue'),
                    subtitle: Text(
                      currentLang,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () =>
                        Navigator.pushNamed(context, '/select-language'),
                  ),
                ),

                // VIBRATE
                _cell(
                  child: SwitchListTile(
                    value: vibrate,
                    onChanged: (v) => setState(() => vibrate = v),
                    title: Text(t['vibrate'] ?? 'Vibrate'),
                    subtitle:
                        Text(t['vibrate_desc'] ?? 'Vibrate on successful scan'),
                    activeColor: AppColors.green,
                  ),
                ),

                // BEEP
                _cell(
                  child: SwitchListTile(
                    value: beep,
                    onChanged: (v) => setState(() => beep = v),
                    title: Text(t['beep'] ?? 'Beep'),
                    subtitle:
                        Text(t['beep_desc'] ?? 'Beep on successful scan'),
                    activeColor: AppColors.green,
                  ),
                ),

                // HISTORY
                _cell(
                  child: SwitchListTile(
                    value: history,
                    onChanged: (v) => setState(() => history = v),
                    title: Text(t['history'] ?? 'History'),
                    subtitle:
                        Text(t['history_desc'] ?? 'Save history of your scans'),
                    activeColor: AppColors.green,
                  ),
                ),

                // FEEDBACK
                _cell(
                  child: ListTile(
                    title: Text(t['send_feedback'] ?? 'Send Feedback'),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),

          const BottomNavBar(active: BottomTab.settings),
        ],
      ),
    );
  }

  Widget _cell({required Widget child}) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 1),
      child: child,
    );
  }
}
