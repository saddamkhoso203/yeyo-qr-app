import 'package:flutter/material.dart';
import 'lang_en.dart';
import 'lang_fr.dart';

class T extends InheritedWidget {
  final Locale locale;
  late final Map<String, String> _strings;

  T({
    super.key,
    required this.locale,
    required super.child,
  }) {
    _strings = _load(locale.languageCode);
  }

  static T get(BuildContext context) {
    final T? result =
        context.dependOnInheritedWidgetOfExactType<T>();
    assert(result != null, 'Translator not found in context');
    return result!;
  }

  static Map<String, String> _load(String code) {
    switch (code) {
      case 'fr':
        return LangFr.map;
      case 'en':
      default:
        return LangEn.map;
    }
  }

  String? operator [](String key) => _strings[key];

  Map<String, String> get map => _strings;

  @override
  bool updateShouldNotify(T oldWidget) {
    return oldWidget.locale.languageCode != locale.languageCode;
  }
}
