import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScanFeedback {
  static Future<void> onSuccess() async {
    final prefs = await SharedPreferences.getInstance();

    final vibrate = prefs.getBool('vibrate') ?? true;
    final beep = prefs.getBool('beep') ?? false;

    if (vibrate) {
      HapticFeedback.mediumImpact();
    }

    if (beep) {
      SystemSound.play(SystemSoundType.click);
    }
  }
}
