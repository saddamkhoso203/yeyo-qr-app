import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import '../theme/app_colors.dart';
import '../Languages/translator.dart';
import '../main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

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
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      vibrate = prefs.getBool('vibrate') ?? true;
      beep = prefs.getBool('beep') ?? false;
      history = prefs.getBool('history') ?? true;
    });
  }

  Future<void> _saveSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    final t = T.get(context);

    final locale = getCurrentLocale(context);
    final langCode = locale.languageCode;

    final currentLang = langCode == 'fr'
        ? (t['lang_fr'] ?? 'Français')
        : (t['lang_en'] ?? 'English');

    return Scaffold(
      appBar: AppBar(title: Text(t['settings'] ?? 'Settings')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                // Language
                ListTile(
                  title: Text(t['language'] ?? 'Language'),
                  subtitle: Text(
                    currentLang,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.pushNamed(context, '/select-language'),
                ),

                const Divider(),

                // Vibrate
                SwitchListTile(
                  title: Text(t['vibrate'] ?? 'Vibrate'),
                  subtitle: Text(
                    t['vibrate_desc'] ?? 'Vibrate on successful scan',
                  ),
                  value: vibrate,
                  onChanged: (value) async {
                    setState(() => vibrate = value);
                    await _saveSetting('vibrate', value);

                    if (value) {
                      HapticFeedback.mediumImpact();
                    }
                  },
                ),

                // Beep
                SwitchListTile(
                  title: Text(t['beep'] ?? 'Beep'),
                  subtitle: Text(t['beep_desc'] ?? 'Beep on successful scan'),
                  value: beep,
                  onChanged: (value) async {
                    setState(() => beep = value);
                    await _saveSetting('beep', value);

                    if (value) {
                      SystemSound.play(SystemSoundType.click);
                    }
                  },
                ),

                // History
                SwitchListTile(
                  title: Text(t['history'] ?? 'History'),
                  subtitle: Text(
                    t['history_desc'] ?? 'Save history of your scans',
                  ),
                  value: history,
                  onChanged: (value) async {
                    setState(() => history = value);
                    await _saveSetting('history', value);
                  },
                ),

                const Divider(),

                // Send Feedback
                ListTile(
                  title: Text(t['send_feedback'] ?? 'Send Feedback'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: open email / feedback screen
                  },
                ),
              ],
            ),
          ),
          const BottomNavBar(active: BottomTab.settings),
        ],
      ),
    );
  }
}
