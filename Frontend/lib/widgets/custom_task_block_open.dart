import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:project_pal/core/app_export.dart';

class TaskBlockOpenWidget extends StatefulWidget {
  final String subject;
  final String date;
  final String teacher;
  final int userId;
  final int studentId;
  final String instruction;
  final String taskLink;
  final int taskId;

  TaskBlockOpenWidget({
    required this.subject,
    required this.date,
    required this.teacher,
    required this.userId,
    required this.instruction,
    required this.taskLink,
    required this.taskId,
    required this.studentId,
  });

  @override
  _TaskBlockOpenWidgetState createState() => _TaskBlockOpenWidgetState();
}

class _TaskBlockOpenWidgetState extends State<TaskBlockOpenWidget> {
  FigmaTextStyles figmaTextStyles = FigmaTextStyles();
  final ApiService apiService = ApiService();
  int? answerId;
  DateTime? submissionDate;
  String teacherComment = '';
  int? teacherGrade;
  String? answerLink;
  late User user;
  int? selectedGrade; // Для выбора оценки

  late Future<void> _taskAnswerFuture;

  @override
  void initState() {
    super.initState();
    _taskAnswerFuture = _loadTaskAnswer();
  }

  Future<void> _loadTaskAnswer() async {
    try {
      String token = await apiService.getJwtToken() ?? '';
      user = await apiService.getUserById(token, widget.userId);
      final List<Map<String, dynamic>> data =
          await apiService.getTaskAnswerByTaskId(token, widget.taskId);
      if (data.isNotEmpty) {
        setState(() {
          answerId = data[0]['id'];
          submissionDate = data[0]['submissionDate'] != null
              ? DateTime.parse(data[0]['submissionDate'])
              : DateTime.now();
          teacherComment = data[0]['teacherCommentary'] ?? '';
          teacherGrade = data[0]['grade'];
          answerLink = data[0]['fileLink'] ?? '';
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
    return FutureBuilder<void>(
      future: _taskAnswerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Ошибка загрузки данных'));
        } else {
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
                                      style: figmaTextStyles.header1Medium
                                          .copyWith(
                                        color: FigmaColors.darkBlueMain,
                                      ),
                                    ),
                                    CustomText(
                                      text: widget.teacher,
                                      style:
                                          figmaTextStyles.regularText.copyWith(
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
                                      style: figmaTextStyles.headerTextMedium
                                          .copyWith(
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
                          CustomText(
                            text: 'Файл от предподавателя:',
                            style: figmaTextStyles.header1Medium.copyWith(
                              color: FigmaColors.darkBlueMain,
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              print(widget.taskLink);
                              String? token = await apiService.getJwtToken();
                              String? filepath =
                                  await apiService.downloadTaskFile(
                                      token!, widget.taskId, widget.taskLink);
                              openFile(filepath!);
                            },
                            child: Text(
                              widget.taskLink,
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          CustomText(
                            text: 'Ответ на задание:',
                            style: figmaTextStyles.header1Medium.copyWith(
                              color: FigmaColors.darkBlueMain,
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              String? token = await apiService.getJwtToken();
                              String? filepath =
                                  await apiService.downloadTaskAnswer(
                                      token!, answerId!, answerLink!);
                              if (filepath != null) {
                                openFile(filepath);
                              }
                            },
                            child: Text(
                              answerLink ?? 'Пусто',
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
                          // Отображение текущей оценки или текста, если оценка не установлена
                          CustomText(
                            text: teacherGrade != 0
                                ? '$teacherGrade'
                                : 'Работа еще не оценена',
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
                  if (user.role != 'STUDENT')
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: CustomText(
                        text: "Оценка за работу",
                        style: figmaTextStyles.caption1Medium
                            .copyWith(color: FigmaColors.darkBlueMain),
                        align: TextAlign.center,
                      ),
                    ),
                  // Выбор оценки для преподавателей
                  if (user.role != 'STUDENT')
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: DropdownButton<int>(
                        value: selectedGrade,
                        hint: Text('Выберите оценку'),
                        items: [0, 1, 2, 3, 4, 5].map((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                        onChanged: (int? value) {
                          setState(() {
                            selectedGrade = value;
                          });
                        },
                      ),
                    ),
                  if (user.role != 'STUDENT')
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 60, vertical: 6),
                      child: CustomButton(
                        text: 'Поставить оценку',
                        onPressed: () async {
                          try {
                            String token = await apiService.getJwtToken() ?? '';
                            print(token);
                            await apiService.updateTaskAnswer(
                              token: token,
                              id: answerId!,
                              taskId: widget.taskId,
                              studentUserId: widget.userId,
                              submissionDate:
                                  submissionDate?.toIso8601String() ?? '',
                              teacherCommentary: teacherComment,
                              grade: selectedGrade ?? 0,
                              fileLink: answerLink ?? '',
                            );
                            AppRoutes.navigateToPageWithFadeTransition(
                                context, TasksPage(userId: widget.userId));
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Работа оценена'),
                                )
                            );
                          } catch (e) {
                            print('Error uploading file: $e');
                          }
                        },
                        figmaTextStyles: figmaTextStyles,
                        showArrows: false,
                      ),
                    ),
                  SizedBox(height: 16),
                  // Кнопка "Прикрепить ответ" для студентов
                  if (user.role == 'STUDENT')
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
                            if (answerId != null) {
                              await apiService.updateTaskAnswer(
                                token: token,
                                id: answerId!,
                                taskId: widget.taskId,
                                studentUserId: widget.studentId,
                                submissionDate:
                                    submissionDate?.toIso8601String() ?? '',
                                teacherCommentary: teacherComment,
                                grade: teacherGrade ?? 0,
                                fileLink: '$fileName',
                              );
                              AppRoutes.navigateToPageWithFadeTransition(
                                  context, TasksPage(userId: widget.userId));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Работа отправлена'),
                                ),
                              );
                            } else {
                              print('Error: answer ID is null');
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
            ),
          );
        }
      },
    );
  }

  Color _getTaskColor() {
    int remainingDays = int.parse(widget.date);
    int? grade = teacherGrade;

    if (remainingDays <= 0 || (grade == null || grade == 2)) {
      return Color(0xFFC55353); // Цвет C55353
    } else if (grade == 0) {
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
