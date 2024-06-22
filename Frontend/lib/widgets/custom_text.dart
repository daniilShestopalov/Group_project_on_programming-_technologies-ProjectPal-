import 'package:project_pal/core/app_export.dart';

class CustomText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? align;
  final overflow;
  final softWrap;

  const CustomText({
    Key? key,
    required this.text,
    this.style,
    this.align, this.overflow, this.softWrap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overflow,
      softWrap: softWrap,
      style: style,
      textAlign: align,
    );
  }
}

