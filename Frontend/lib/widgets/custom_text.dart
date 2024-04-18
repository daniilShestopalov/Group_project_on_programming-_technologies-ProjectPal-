import 'package:project_pal/core/app_export.dart';

class CustomText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? align;

  const CustomText({
    Key? key,
    required this.text,
    this.style,
    this.align,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
      textAlign: align,
    );
  }
}

