import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/services/language_service.dart';
import '../../../../l10n/app_localizations.dart';

class LanguageDialogWidget extends StatelessWidget {
  const LanguageDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final languageService = sl<LanguageService>();

    return AlertDialog(
      title: Text(AppLocalizations.of(context).language),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(AppLocalizations.of(context).english),
            leading: Checkbox(
              value: languageService.isEnglish,
              onChanged: (bool? value) {
                if (value != null) {
                  languageService.setEnglish();
                }
              },
            ),
            onTap: () {
              languageService.setEnglish();
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context).arabic),
            leading: Checkbox(
              value: languageService.isArabic,
              onChanged: (bool? value) {
                if (value != null) {
                  languageService.setArabic();
                }
              },
            ),
            onTap: () {
              languageService.setArabic();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
