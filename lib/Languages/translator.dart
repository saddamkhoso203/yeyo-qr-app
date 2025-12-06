import 'package:flutter/material.dart';

import 'lang_en.dart' as en;
import 'lang_fr.dart' as fr;

class T extends InheritedWidget {
  final Locale locale;

  const T({
    super.key,
    required this.locale,
    required Widget child,
  }) : super(child: child);

  /// Normal usage in screens
  static Map<String, String> get(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<T>();
    final code = widget?.locale.languageCode ?? 'en';

    if (code == 'fr') {
      return fr.LangFr.map;
    }
    return en.LangEn.map;
  }

  /// Optional: direct lookup by locale (rarely needed)
  static Map<String, String> getFromLocale(Locale locale) {
    final code = locale.languageCode;
    if (code == 'fr') {
      return fr.LangFr.map;
    }
    return en.LangEn.map;
  }

  @override
  bool updateShouldNotify(T oldWidget) => oldWidget.locale != locale;
}
