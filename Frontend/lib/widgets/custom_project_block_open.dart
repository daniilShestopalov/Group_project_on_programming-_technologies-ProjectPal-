import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:project_pal/core/app_export.dart';

class ProjectBlockOpenWidget extends StatefulWidget {
  final String subject;
  final String date;
  final String teacher;
  final int userId;
  final String instruction;
  final int taskId;

  ProjectBlockOpenWidget({
    required this.subject,
    required this.date,
    required this.teacher,
    required this.userId,
    required this.instruction,
    required this.taskId,
  });

  @override
  _ProjectBlockOpenWidgetState createState() => _ProjectBlockOpenWidgetState();
}

class _ProjectBlockOpenWidgetState extends State<ProjectBlockOpenWidget> {
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();
  final ApiService apiService = ApiService();
  int? answerId;
  DateTime? submissionDate;
  String teacherComment = '';
  int? teacherGrade;
  String? taskLink;
  String answerLink = '';

  @override
  void initState() {
    super.initState();
    _loadTaskAnswer();
  }

  Future<void> _loadTaskAnswer() async {
    try {
      String token = await apiService.getJwtToken() ?? '';
      final Map<String, dynamic> data =
      await apiService.getProjectAnswerByProjectId(token, widget.taskId);
      print(data);
      if (data.isNotEmpty) {
        setState(() {
          answerId = data['id'];
          submissionDate = data['submissionDate'] != null
              ? DateTime.parse(data['submissionDate'])
              : DateTime.now();
          teacherComment = data['teacherCommentary'] ?? '';
          teacherGrade = data['grade'];
          answerLink = data['fileLink'] ?? '';
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
    } else if (days < 0 && teacherGrade != null) {
      remainingDaysText = 'Выполнено';
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
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 16.0),
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
                      text: 'Описание:',
                      style: figmaTextStyles.header1Medium.copyWith(
                        color: FigmaColors.darkBlueMain,
                      ),
                    ),
                    CustomText(
                      text: widget.instruction.isNotEmpty
                          ? widget.instruction
                          : 'Описание для задания отсутствует',
                      style: figmaTextStyles.regularText.copyWith(
                        color: FigmaColors.darkBlueMain,
                      ),
                    ),
                    SizedBox(height: 16),
                    if (taskLink != null) ...[
                      CustomText(
                        text: 'Файл от предподавателя:',
                        style: figmaTextStyles.header1Medium.copyWith(
                          color: FigmaColors.darkBlueMain,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          // Открыть ссылку на ответ
                        },
                        child: Text(
                          taskLink!,
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                    CustomText(
                      text: 'Ответ на задание:',
                      style: figmaTextStyles.header1Medium.copyWith(
                        color: FigmaColors.darkBlueMain,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        print(answerLink);
                       // String? token = await apiService.getJwtToken();
                       // String? filepath = await apiService
                        //    .downloadTaskAnswer(token!, answerLink);
                        //if (filepath != null) {
                         // openFile(filepath);
                       // }
                      },
                      child: Text(
                        answerLink,
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
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
                      text: teacherComment.isNotEmpty
                          ? teacherComment
                          : 'Комментарий отсутствует',
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
                  text: 'Прикрепить ответ',
                  onPressed: () async {
                    FilePickerResult? result =
                    await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['pdf'],
                    );
                    if (result != null && result.files.isNotEmpty) {
                      try {
                        String token = await apiService.getJwtToken() ?? '';
                        String filePath = result.files.first.path!;
                        File file = File(filePath);
                        String fileName = file.path.split('/').last;
                        await apiService.uploadTaskAnswerFile(token, file);
                        if (teacherGrade != null && answerId != null) {
                          await apiService.updateTaskAnswer(
                            token: token,
                            id: answerId!,
                            taskId: widget.taskId,
                            studentUserId: widget.userId,
                            submissionDate:
                            submissionDate?.toIso8601String() ?? '',
                            teacherCommentary: teacherComment,
                            grade: teacherGrade!,
                            fileLink: '$fileName',
                          );
                        } else {
                          print('Error: Teacher grade or answer ID is null');
                        }
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

  void openFile(String filePath) async {
    File file = File(filePath);
    if (file.existsSync()) {
      try {
        // Открываем файл с помощью openFile
        await OpenFile.open(filePath);
      } catch (e) {
        print('Ошибка при открытии файла: $e');
      }
    } else {
      print('Файл не найден: $filePath');
    }
  }
}
