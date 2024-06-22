import 'package:flutter/material.dart';
import 'package:project_pal/core/app_export.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final bool enabled;
  final int? maxLines; // Новый параметр для задания максимального количества строк
  final TextEditingController? controller;
  final FigmaTextStyles figmaTextStyles;
  final onChanged;

  const CustomTextField({
    Key? key,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
    this.maxLines, // Добавляем параметр для максимального количества строк
    this.controller,
    required this.figmaTextStyles,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
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
