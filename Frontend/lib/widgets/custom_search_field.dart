import 'package:flutter/material.dart';
import 'package:project_pal/core/app_export.dart';

class CustomSearchField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final FigmaTextStyles figmaTextStyles;
  final VoidCallback onSearch;

  const CustomSearchField({
    Key? key,
    required this.hintText,
    this.controller,
    required this.figmaTextStyles,
    required this.onSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
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
          ),
        ),
        IconButton(
          icon: Icon(Icons.search, color: FigmaColors.darkBlueMain),
          onPressed: onSearch,
        ),
      ],
    );
  }
}
