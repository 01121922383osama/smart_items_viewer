import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/services/theme_service.dart';
import '../../../../l10n/app_localizations.dart';

class ThemeDialogWidget extends StatelessWidget {
  const ThemeDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = sl<ThemeService>();

    return AlertDialog(
      title: Text(AppLocalizations.of(context).theme),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(AppLocalizations.of(context).light),
            leading: Checkbox(
              value: themeService.isLightMode,
              onChanged: (bool? value) {
                if (value != null) {
                  themeService.setLightMode();
                }
              },
            ),
            onTap: () {
              themeService.setLightMode();
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context).dark),
            leading: Checkbox(
              value: themeService.isDarkMode,
              onChanged: (bool? value) {
                if (value != null) {
                  themeService.setDarkMode();
                }
              },
            ),
            onTap: () {
              themeService.setDarkMode();
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context).system),
            leading: Checkbox(
              value: themeService.isSystemMode,
              onChanged: (bool? value) {
                if (value != null) {
                  themeService.setSystemMode();
                }
              },
            ),
            onTap: () {
              themeService.setSystemMode();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
