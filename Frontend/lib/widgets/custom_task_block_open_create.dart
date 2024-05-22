import 'package:file_picker/file_picker.dart';
import 'package:project_pal/core/app_export.dart';

class TaskBlockOpenCreateWidget extends StatefulWidget {
  final String? subject;
  final String? date;
  final String? teacher;
  final List<Task>? tasks;
  final int userId;
  final String? instruction;
  final String? grade;
  final String? comment;

  TaskBlockOpenCreateWidget({
    required this.subject,
    required this.date,
    required this.teacher,
    required this.tasks,
    required this.userId,
    required this.instruction,
    this.grade,
    this.comment,
  });

  @override
  _TaskBlockOpenCreateWidgetState createState() => _TaskBlockOpenCreateWidgetState();
}

class _TaskBlockOpenCreateWidgetState extends State<TaskBlockOpenCreateWidget> {
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();
  PlatformFile? _selectedFile;

  @override
  Widget build(BuildContext context) {
    String remainingDaysText;
   /* int? days = int.tryParse(widget.date ?? '');

    if (days == 1) {
      remainingDaysText = (widget.date! +  ' день');
    } else if (days! > 1 && days < 5) {
      remainingDaysText = (widget.date! +  ' дня');
    } else if (days > 5){
      remainingDaysText = (widget.date! + ' дней');
    } else {
      remainingDaysText = 'Закрыто';
    }
    */

    return Container(
      width: 375,
      height: 607,
      decoration: BoxDecoration(
        color: Color(0xFFFCEBC1),
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
                      CustomTextField(
                        hintText: 'widget.subject', figmaTextStyles: figmaTextStyles,
                      ),
                      CustomTextField(
                        hintText: 'widget.teacher', figmaTextStyles: figmaTextStyles,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset(ImageConstant.timeIcon),
                      SizedBox(width: 4),
                      CustomTextField(
                        hintText: '2', figmaTextStyles: figmaTextStyles,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: FigmaColors.lightBlueBackground,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(width: 4),
    /*  for (var task in widget.tasks)
     Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              Checkbox(
                                value: task.isCompleted,
                                onChanged: null, // Заблокировать нажатие
                                activeColor: task.isCompleted ? FigmaColors.darkBlueMain : FigmaColors.darkBlueMain, // Цвет заполнения
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  task.description,
                                  style: TextStyle(
                                    color: FigmaColors.darkBlueMain,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ), */
                    ],
                  ),
                  SizedBox(height: 8),
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
              text: 'widget.instruction.isNotEmpty ? widget.instruction :,',
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
                     /* for (var task in widget.tasks) {
                        task.isCompleted = true;
                      } */
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
              text: '',
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
              text: '',
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
}
