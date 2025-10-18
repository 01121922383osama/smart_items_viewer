import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/di/injection.dart';
import 'core/network/connectivity_guard.dart';
import 'core/services/language_service.dart';
import 'core/services/theme_service.dart';
import 'features/items/presentation/pages/items_page.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await init();

  await sl<ConnectivityGuard>().initialize();

  await sl<LanguageService>().initialize();
  await sl<ThemeService>().initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([sl<LanguageService>(), sl<ThemeService>()]),
      builder: (context, child) {
        return MaterialApp(
          title: 'Smart Items Viewer',
          debugShowCheckedModeBanner: false,
          locale: sl<LanguageService>().currentLocale,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          themeMode: sl<ThemeService>().currentThemeMode,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en', ''), Locale('ar', '')],
          home: const ItemsPage(),
        );
      },
    );
  }
}
