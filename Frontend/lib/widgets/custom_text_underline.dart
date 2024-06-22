import 'package:project_pal/core/app_export.dart';

class UnderlineText extends StatefulWidget {
  final String text;
  final TextStyle textStyle;
  final Color defaultColor;
  final double underlineHeight;
  final Function()? onTap; // Меняем тип обработчика нажатия

  const UnderlineText({
    Key? key,
    required this.text,
    this.textStyle = const TextStyle(),
    this.defaultColor = Colors.grey,
    this.underlineHeight = 1.0,
    this.onTap,
  }) : super(key: key);

  @override
  _UnderlineTextState createState() => _UnderlineTextState();
}

class _UnderlineTextState extends State<UnderlineText> {
  late Color _underlineColor;

  @override
  void initState() {
    super.initState();
    _underlineColor = widget.defaultColor;
  }

  @override
  Widget build(BuildContext context) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: widget.text, style: widget.textStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    final double textWidth = textPainter.width;

    return GestureDetector(
      onTap: () {
        setState(() {
          // Устанавливаем цвет этого текста
          _underlineColor = FigmaColors.selectorColor;
        });

        widget.onTap?.call(); // Вызываем функцию обратного вызова

        // Получаем список всех детей этого виджета и находим все тексты
        final siblings = context.findAncestorWidgetOfExactType<Row>()?.children;
        if (siblings != null) {
          for (final sibling in siblings) {
            if (sibling is UnderlineText && sibling != this.widget) {
              final state = (sibling.key as GlobalKey<_UnderlineTextState>).currentState;
              state?.resetColor(); // Устанавливаем серый цвет для других текстов
            }
          }
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.text,
            style: widget.textStyle.copyWith(
              color: _underlineColor == FigmaColors.selectorColor
                  ? FigmaColors.darkBlueMain
                  : widget.defaultColor,
            ),
          ),
          SizedBox(height: 2),
          Container(
            height: widget.underlineHeight,
            color: _underlineColor,
            width: textWidth,
          ),
        ],
      ),
    );
  }

  void resetColor() {
    setState(() {
      // Сбрасываем цвет этого текста к серому
      _underlineColor = widget.defaultColor;
    });
  }
}
