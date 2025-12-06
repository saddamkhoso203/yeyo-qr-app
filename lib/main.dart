import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'Languages/translator.dart';
import 'screens/SplashScreen.dart';
import 'theme/app_colors.dart';

import 'screens/scan_qr_screen.dart';
import 'screens/approved_screen.dart';
import 'screens/not_approved_screen.dart';
import 'screens/history_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/select_language_screen.dart';
import 'screens/more_screen.dart';
import 'screens/about_screen.dart';
import 'screens/help_screen.dart';
import 'screens/privacy_policy_screen.dart';

void main() {
  runApp(const YoyoApp());
}

// Root widget → holds locale and rebuilds when changed.
class YoyoApp extends StatefulWidget {
  const YoyoApp({super.key});

  static _YoyoAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_YoyoAppState>();

  @override
  State<YoyoApp> createState() => _YoyoAppState();
}

class _YoyoAppState extends State<YoyoApp> {
  Locale _locale = const Locale('en');

  void changeLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  Locale get currentLocale => _locale;

  @override
  Widget build(BuildContext context) {
    return T(
      locale: _locale,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Yeyo QR',
        locale: _locale,

        supportedLocales: const [
          Locale('en'),
          Locale('fr'),
        ],

        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],

        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.lightBackground,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            iconTheme: IconThemeData(color: AppColors.textPrimary),
          ),
        ),

        initialRoute: '/splash',

        routes: {
          '/splash': (_) => const SplashScreen(),
          '/scan': (_) => const ScanQrScreen(),
          '/approved': (_) => const ApprovedScreen(),
          '/not-approved': (_) => const NotApprovedScreen(),
          '/history': (_) => const HistoryScreen(),
          '/settings': (_) => const SettingsScreen(),
          '/select-language': (_) => const SelectLanguageScreen(),
          '/more': (_) => const MoreScreen(),
          '/about': (_) => const AboutScreen(),
          '/help': (_) => const HelpScreen(),
          '/privacy': (_) => const PrivacyPolicyScreen(),
        },
      ),
    );
  }
}

/// Change locale globally
void setLocale(BuildContext context, Locale locale) {
  final appState = YoyoApp.of(context);
  appState?.changeLocale(locale);
}

/// Get current selected locale
Locale getCurrentLocale(BuildContext context) {
  final appState = YoyoApp.of(context);
  return appState?.currentLocale ?? const Locale('en');
}
