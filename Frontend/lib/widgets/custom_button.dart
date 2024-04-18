import 'package:flutter/material.dart';
import 'package:project_pal/core/app_export.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final FigmaTextStyles figmaTextStyles;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.figmaTextStyles,
  }) : super(key: key);

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
        widget.onPressed();
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        height: 55,
        decoration: BoxDecoration(
          color: _isPressed ? FigmaColors.darkBlueMain.withOpacity(0.5) : FigmaColors.darkBlueMain,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              text: widget.text,
              style: widget.figmaTextStyles.header2Regular.copyWith(
                color: FigmaColors.whiteText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
