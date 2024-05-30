import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:project_pal/core/app_export.dart';

class TaskBlockOpenWidget extends StatefulWidget {
  final String subject;
  final String date;
  final String teacher;
  final int userId;
  final String instruction;
  final int taskId;

  TaskBlockOpenWidget({
    required this.subject,
    required this.date,
    required this.teacher,
    required this.userId,
    required this.instruction,
    required this.taskId,
  });

  @override
  _TaskBlockOpenWidgetState createState() => _TaskBlockOpenWidgetState();
}

class _TaskBlockOpenWidgetState extends State<TaskBlockOpenWidget> {
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();
  PlatformFile? _selectedFile;
  final ApiService apiService = ApiService();
  String? teacherComment;
  int? teacherGrade;
  String? answerLink;

  @override
  void initState() {
    super.initState();
    _loadTaskAnswer();
  }

  Future<void> _loadTaskAnswer() async {
    try {
      String token = await apiService.getJwtToken() ?? '';
      final List<Map<String, dynamic>> data =
      await apiService.getTaskAnswerByTaskId(token, widget.taskId);
      if (data.isNotEmpty) {
        setState(() {
          teacherComment = data[0]['teacherCommentary'];
          teacherGrade = data[0]['grade'];
          answerLink = data[0]['fileLink'];
        });
      } else {
        print('No task answer found');
      }
    } catch (e) {
      print('Failed to load task answer: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    String remainingDaysText;
    int days = int.parse(widget.date);

    if (days == 1) {
      remainingDaysText = '${widget.date} день';
    } else if (days > 1 && days < 5) {
      remainingDaysText = '${widget.date} дня';
    } else if (days >= 5) {
      remainingDaysText = '${widget.date} дней';
    } else {
      remainingDaysText = 'Просрочено';
    }

    return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
          Container(
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
          padding:
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
          Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
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
                    style:
                    figmaTextStyles.headerTextMedium.copyWith(
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
          text: widget.instruction.isNotEmpty
              ? widget.instruction
              : 'Инструкция для работы отсутствует',
          style: figmaTextStyles.regularText.copyWith(
            color: FigmaColors.darkBlueMain,
          ),
        ),
        SizedBox(height: 16),
        if (answerLink != null) ...[
    CustomText(
    text: 'Ссылка на ответ:',
    style: figmaTextStyles.header1Medium.copyWith(
    color: FigmaColors.darkBlueMain,
    ),
    ),
    InkWell(
    onTap: () {
    // Открыть ссылку на ответ
    },
    child: Text(
    answerLink!,
    style: TextStyle(
    color: Colors.blue,
      decoration: TextDecoration.underline,
    ),
    ),
    ),
          SizedBox(height: 16),
        ],
                CustomText(
                  text: 'Оценка от преподавателя:',
                  style: figmaTextStyles.header1Medium.copyWith(
                    color: FigmaColors.darkBlueMain,
                  ),
                ),
                CustomText(
                  text: '${teacherGrade ?? "Работа еще не оценена"}',
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
                  text:
                  '${teacherComment ?? "Работа еще не прокомментирована"}',
                  style: figmaTextStyles.regularText.copyWith(
                    color: FigmaColors.darkBlueMain,
                  ),
                ),
                SizedBox(height: 16),
              ],
          ),
        ),
          ),
                SizedBox(height: 16),
                Column(
                  children: [
                    CustomButton(
                      text: 'Предоставить работу',
                      onPressed: () async {
                        FilePickerResult? result =
                        await FilePicker.platform.pickFiles();
                        if (result != null) {
                          setState(() {
                            _selectedFile = result.files.first;
                          });
                        }
                      },
                      figmaTextStyles: figmaTextStyles,
                      showArrows: false,
                    ),
                    SizedBox(height: 16),
                    CustomButton(
                      text: 'Прикрепить файл',
                      onPressed: () async {
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf'],
                        );
                        if (result != null && result.files.isNotEmpty) {
                          try {
                            String token = await apiService.getJwtToken() ?? '';
                            String filePath = result.files.first.path!;
                            File file = File(filePath);
                            await apiService.uploadTaskAnswerFile(token, file);
                          } catch (e) {
                            print('Error uploading file: $e');
                          }
                        } else {
                          print('No file selected');
                        }
                      },
                      figmaTextStyles: figmaTextStyles,
                      showArrows: false,
                    ),
                  ],
                ),
              ],
          ),
        ),
    );
  }

  Color _getTaskColor() {
    int remainingDays = int.parse(widget.date);
    int? grade = teacherGrade;

    if (remainingDays <= 0 && (grade == null || grade <= 2)) {
      return Color(0xFFC55353); // Цвет C55353
    } else if (grade == null) {
      return Color(0xFFFCEBC1); // Цвет FCEBC1
    } else if (grade > 2) {
      return Color(0xFF85C8A0); // Цвет 85C8A0
    } else {
      return FigmaColors.editTask; // Возвращаем исходный цвет
    }
  }
}

