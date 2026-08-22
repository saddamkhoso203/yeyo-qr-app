import 'dart:async';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScanFeedback {
  /// ✅ SUCCESS: soft vibration
  static Future<void> onSuccess() async {
    final prefs = await SharedPreferences.getInstance();

    final vibrate = prefs.getBool('vibrate') ?? true;
    if (!vibrate) return;

    if (await _isDeviceSilent()) return;

    final strength = prefs.getString('vibration_strength') ?? 'medium';

    _vibrate(strength);
  }

  /// ❌ ERROR: double vibration
  static Future<void> onError() async {
    final prefs = await SharedPreferences.getInstance();

    final vibrate = prefs.getBool('vibrate') ?? true;
    if (!vibrate) return;

    if (await _isDeviceSilent()) return;

    final strength = prefs.getString('vibration_strength') ?? 'medium';

    _vibrate(strength);
    await Future.delayed(const Duration(milliseconds: 120));
    _vibrate(strength);
  }

  /// 🔊 vibration strength mapping
  static void _vibrate(String strength) {
    switch (strength) {
      case 'light':
        HapticFeedback.lightImpact();
        break;
      case 'strong':
        HapticFeedback.heavyImpact();
        break;
      case 'medium':
      default:
        HapticFeedback.mediumImpact();
        break;
    }
  }

  /// 🔕 Detect silent / do-not-disturb mode
  static Future<bool> _isDeviceSilent() async {
    try {
      final result = await SystemChannels.platform.invokeMethod<int>(
        'SystemSound.getVolume',
      );
      return result == 0;
    } catch (_) {
      // fallback: allow vibration
      return false;
    }
  }
}
