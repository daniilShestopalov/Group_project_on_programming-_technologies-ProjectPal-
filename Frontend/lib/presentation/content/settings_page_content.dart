import 'package:project_pal/core/app_export.dart';

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
              text: 'Настройки',
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
                text: 'Язык',
                onPressed: () {
                  // Обработчик нажатия кнопки "Язык"
                },
                figmaTextStyles: figmaTextStyles,
                showArrows: false,
              ),
              SizedBox(height: 16),
              CustomButton(
                text: 'Уведомления и звуки',
                onPressed: () {
                  // Обработчик нажатия кнопки "Уведомления и звуки"
                },
                figmaTextStyles: figmaTextStyles,
                showArrows: false,
              ),
              SizedBox(height: 16),
              CustomButton(
                text: 'Данные и память',
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
