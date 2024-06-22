import 'package:flutter/material.dart';
import 'package:project_pal/core/app_export.dart';

import '../../core/utils/app_localizations.dart';  // Ваши импорты

class SettingsPageContent extends StatefulWidget {
  final int userId;

  const SettingsPageContent({Key? key, required this.userId}) : super(key: key);

  @override
  _SettingsPageContentState createState() => _SettingsPageContentState();
}

class _SettingsPageContentState extends State<SettingsPageContent> {
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Center(
            child: CustomText(
              text: AppLocalizations.of(context)?.translate('settings') ?? 'Settings',
              style: figmaTextStyles.header1Medium.copyWith(
                color: FigmaColors.darkBlueMain,
              ),
            ),
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                text: AppLocalizations.of(context)?.translate('language') ?? 'Language',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(AppLocalizations.of(context)?.translate('language') ?? 'Language'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              child: Text('English'),
                              onPressed: () { // Изменить язык на английский
                                AppLocalizations.of(context)?.load();
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text('Русский'),
                              onPressed: () {
                                AppLocalizations.of(context)?.load();
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                figmaTextStyles: figmaTextStyles,
                showArrows: false,
              ),
              SizedBox(height: 16),
              CustomButton(
                text: AppLocalizations.of(context)?.translate('notifications') ?? 'Notifications and Sounds',
                onPressed: () {
                  // Обработчик нажатия кнопки "Уведомления и звуки"
                },
                figmaTextStyles: figmaTextStyles,
                showArrows: false,
              ),
              SizedBox(height: 16),
              CustomButton(
                text: AppLocalizations.of(context)?.translate('data') ?? 'Data and Storage',
                onPressed: () {
                  // Обработчик нажатия кнопки "Данные и память"
                },
                figmaTextStyles: figmaTextStyles,
                showArrows: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
