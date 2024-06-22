import 'package:project_pal/core/app_export.dart';

class CustomCheckbox extends StatefulWidget {
  final ValueChanged<bool> onChanged;
  final bool value;
  final String? label;
  final FigmaTextStyles figmaTextStyles;

  const CustomCheckbox({
    Key? key,
    required this.onChanged,
    required this.value,
    this.label,
    required this.figmaTextStyles,
  }) : super(key: key);

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: _isChecked,
          onChanged: (value) {
            setState(() {
              _isChecked = value!;
              widget.onChanged(value);
            });
          },
          activeColor: FigmaColors.darkBlueMain, // Устанавливаем цвет галочки
        ),
        if (widget.label != null)
          Text(
            widget.label!,
            style: widget.figmaTextStyles.subHeaderRegular.copyWith(
              color: FigmaColors.darkBlueMain,
            ),
          ),
      ],
    );
  }
}
