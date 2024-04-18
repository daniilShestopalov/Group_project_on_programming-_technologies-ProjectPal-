import 'package:project_pal/core/app_export.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final bool enabled;
  final FigmaTextStyles figmaTextStyles;

  const CustomTextField({
    Key? key,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.enabled = true, // По умолчанию поле активно
    required this.figmaTextStyles
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: enabled, // Установка активности поля
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: figmaTextStyles.headerTextRegular.copyWith(
        color: FigmaColors.darkBlueMain,
      ),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: figmaTextStyles.headerTextRegular.copyWith(
          color: FigmaColors.darkBlueMain,
        ),
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      ),
    );
  }
}
