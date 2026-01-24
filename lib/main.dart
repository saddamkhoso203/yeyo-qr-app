// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yeyo_qr_app/firebase_options.dart';

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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final prefs = await SharedPreferences.getInstance();
  final savedLangCode = prefs.getString('lang_code') ?? 'en';

  runApp(YoyoApp(initialLocale: Locale(savedLangCode)));
}

// Root widget → holds locale and rebuilds when changed.
class YoyoApp extends StatefulWidget {
  final Locale initialLocale;

  const YoyoApp({super.key, required this.initialLocale});

  static _YoyoAppState of(BuildContext context) {
    return context.findAncestorStateOfType<_YoyoAppState>()!;
  }

  @override
  State<YoyoApp> createState() => _YoyoAppState();
}

class _YoyoAppState extends State<YoyoApp> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.initialLocale;
  }

  Locale get currentLocale => _locale;

  Future<void> changeLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lang_code', locale.languageCode);

    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return T(
      locale: _locale,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Yeyo QR',
        locale: _locale,

        supportedLocales: const [Locale('en'), Locale('fr')],

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

/// Change locale globally (SAFE)
Future<void> setLocale(BuildContext context, Locale locale) async {
  await YoyoApp.of(context).changeLocale(locale);
}

/// Get current selected locale (SAFE)
Locale getCurrentLocale(BuildContext context) {
  return YoyoApp.of(context).currentLocale;
}
