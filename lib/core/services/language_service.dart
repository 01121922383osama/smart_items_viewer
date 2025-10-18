import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends ChangeNotifier {
  static const String _languageKey = 'selected_language';
  final SharedPreferences _prefs;

  LanguageService({required SharedPreferences prefs}) : _prefs = prefs;

  Locale _currentLocale = const Locale('en');

  Locale get currentLocale => _currentLocale;

  bool get isArabic => _currentLocale.languageCode == 'ar';
  bool get isEnglish => _currentLocale.languageCode == 'en';

  Future<void> initialize() async {
    final savedLanguage = _prefs.getString(_languageKey);

    if (savedLanguage != null) {
      _currentLocale = Locale(savedLanguage);
    }

    notifyListeners();
  }

  Future<void> setLanguage(Locale locale) async {
    if (_currentLocale == locale) return;

    _currentLocale = locale;

    await _prefs.setString(_languageKey, locale.languageCode);

    notifyListeners();
  }

  Future<void> setEnglish() async {
    await setLanguage(const Locale('en'));
  }

  Future<void> setArabic() async {
    await setLanguage(const Locale('ar'));
  }

  String getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'ar':
        return 'العربية';
      default:
        return 'English';
    }
  }
}
