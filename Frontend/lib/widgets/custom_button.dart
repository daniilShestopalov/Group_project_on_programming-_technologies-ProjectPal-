import 'package:project_pal/core/app_export.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final FigmaTextStyles figmaTextStyles;
  final bool showArrows;
  final VoidCallback? onTapArrowLeft;
  final VoidCallback? onTapArrowRight;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.figmaTextStyles,
    this.showArrows = false,
    this.onTapArrowLeft,
    this.onTapArrowRight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: FigmaColors.darkBlueMain,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showArrows) ...[
              GestureDetector(
                onTap: onTapArrowLeft,
                  child: Icon(
                    Icons.arrow_left,
                    color: Colors.white,
                  ),
                ),
            ],
            CustomText(
              text: text,
              style: figmaTextStyles.header2Regular.copyWith(
                color: FigmaColors.whiteText,
              ),
            ),
            if (showArrows) ...[
              GestureDetector(
                onTap: onTapArrowRight,
                  child: Icon(
                    Icons.arrow_right,
                    color: Colors.white,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

