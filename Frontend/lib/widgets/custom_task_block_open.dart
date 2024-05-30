import 'package:file_picker/file_picker.dart';
import 'package:project_pal/core/app_export.dart';

class TaskBlockOpenWidget extends StatefulWidget {
  final String subject;
  final String date;
  final String teacher;
  final int userId;
  final String instruction;
  final String? grade;
  final String? comment;

  TaskBlockOpenWidget({
    required this.subject,
    required this.date,
    required this.teacher,
    required this.userId,
    required this.instruction,
    this.grade,
    this.comment,
  });

  @override
  _TaskBlockOpenWidgetState createState() => _TaskBlockOpenWidgetState();
}

class _TaskBlockOpenWidgetState extends State<TaskBlockOpenWidget> {
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();
  PlatformFile? _selectedFile;

  @override
  Widget build(BuildContext context) {
    String remainingDaysText;
    int days = int.parse(widget.date);

    if (days == 1) {
      remainingDaysText = widget.date +  ' день';
    } else if (days > 1 && days < 5) {
      remainingDaysText = widget.date +  ' дня';
    } else if (days > 5){
      remainingDaysText = widget.date + ' дней';
    } else {
    remainingDaysText = 'Закрыто';
    }

    return Container(
      width: 375,
      height: 607,
      decoration: BoxDecoration(
        color: _getTaskColor(),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 33.0, horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: widget.subject,
                        style: figmaTextStyles.header1Medium.copyWith(
                          color: FigmaColors.darkBlueMain,
                        ),
                      ),
                      CustomText(
                        text: widget.teacher,
                        style: figmaTextStyles.regularText.copyWith(
                          color: FigmaColors.darkBlueMain,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset(ImageConstant.timeIcon),
                      SizedBox(width: 4),
                      CustomText(
                        text: '$remainingDaysText',
                        style: figmaTextStyles.header2Medium.copyWith(
                          color: FigmaColors.darkBlueMain,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            CustomText(
              text: 'Инструкция для работы:',
              style: figmaTextStyles.header1Medium.copyWith(
                color: FigmaColors.darkBlueMain,
              ),
            ),
            CustomText(
              text: widget.instruction.isNotEmpty ? widget.instruction : 'Инструкция для работы отсутствует',
              style: figmaTextStyles.regularText.copyWith(
                color: FigmaColors.darkBlueMain,
              ),
            ),
            SizedBox(height: 8),
            _selectedFile != null
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomText(
                  text: 'Предоставленный ответ:',
                  style: figmaTextStyles.header1Medium.copyWith(
                    color: FigmaColors.darkBlueMain,
                  ),
                ),
                InkWell(
                  onTap: () {
                    // Открывать файл по нажатию
                  },
                  child: Text(
                    _selectedFile!.name,
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            )
                : Container(),
            SizedBox(height: 16),
            Container(
              alignment: Alignment.center,
              child: CustomButton(
                text: _selectedFile != null ? 'Изменить файл' : 'Предоставить работу',
                onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles();
                  if (result != null) {
                    setState(() {
                      _selectedFile = result.files.first;
                    });
                  }
                },

                figmaTextStyles: figmaTextStyles,
                showArrows: false,
              ),
            ),
            SizedBox(height: 16),
            CustomText(
              text: 'Оценка от преподавателя:',
              style: figmaTextStyles.header1Medium.copyWith(
                color: FigmaColors.darkBlueMain,
              ),
            ),
            CustomText(
              text: '${widget.grade ?? "Работа еще не оценена"}',
              style: figmaTextStyles.regularText.copyWith(
                color: FigmaColors.darkBlueMain,
              ),
            ),
            SizedBox(height: 16),
            CustomText(
              text: 'Комментарий к работе:',
              style: figmaTextStyles.header1Medium.copyWith(
                color: FigmaColors.darkBlueMain,
              ),
            ),
            CustomText(
              text: '${widget.comment ?? "Работа еще непрокомментированна"}',
              style: figmaTextStyles.regularText.copyWith(
                color: FigmaColors.darkBlueMain,
              ),
            ),
            SizedBox(height: 16),
          ],
        ),

      ),
    );
  }

  Color _getTaskColor() {
    int remainingDays = int.parse(widget.date);
    String? grade = widget.grade;

    if (remainingDays <= 0 && (grade == null || int.parse(grade) <= 2)) {
      return Color(0xFFC55353); // Цвет C55353
    } else if (grade == null) {
      return Color(0xFFFCEBC1); // Цвет FCEBC1
    } else if (int.parse(grade) > 2) {
      return Color(0xFF85C8A0); // Цвет 85C8A0
    } else {
      return FigmaColors.editTask; // Возвращаем исходный цвет
    }
  }
}
