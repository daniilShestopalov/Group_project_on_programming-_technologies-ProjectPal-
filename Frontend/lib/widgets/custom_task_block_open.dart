import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:project_pal/core/app_export.dart';

class TaskBlockOpenWidget extends StatefulWidget {
  final String subject;
  final DateTime startDate;
  final DateTime endDate;
  final String teacher;
  final String date;
  final int userId;
  final int groupId;
  final int studentId;
  final int taskId;
  final String description;
  final String taskLink;

  TaskBlockOpenWidget({
    required this.date,
    required this.userId,
    required this.taskId,
    required this.studentId,
    required this.subject,
    required this.teacher,
    required this.description,
    required this.taskLink,
    required this.groupId,
    required this.startDate,
    required this.endDate,
  });

  @override
  _TaskBlockOpenWidgetState createState() => _TaskBlockOpenWidgetState();
}

class _TaskBlockOpenWidgetState extends State<TaskBlockOpenWidget> {
  FigmaTextStyles figmaTextStyles = FigmaTextStyles();
  final ApiService apiService = ApiService();
  late User user;
  TextEditingController commentary = TextEditingController();
  TextEditingController commentaryStudent = TextEditingController();

  int? idAnswer;
  DateTime? submissionDate;
  String? teacherCommentary;
  String? studentCommentary;
  int? grade;
  String? fileLink;

  late Future<void> _taskAnswerFuture;

  @override
  void initState() {
    super.initState();
    _taskAnswerFuture = _loadTaskAnswer();
  }

  Future<void> _loadTaskAnswer() async {
    try {
      String? token = await apiService.getJwtToken();
      if (token == null) {
        throw Exception('Failed to retrieve token');
      }
      user = await apiService.getUserById(token, widget.userId);
      print(widget.taskId);
      print(widget.studentId);
      final Map<String, dynamic> data = await apiService.getTaskAnswerByTaskIdAndByStudentId(
          token, widget.taskId, widget.studentId);
      if (data.isNotEmpty) {
        setState(() {
          idAnswer = data['id'] as int?;
          print(idAnswer);
          submissionDate = data['submissionDate'] != null
              ? DateTime.parse(data['submissionDate'])
              : DateTime.now();
          teacherCommentary = data['teacherCommentary'] as String?;
          studentCommentary = data['studentCommentary'] as String?;
          grade = data['grade'] as int?;
          fileLink = data['fileLink'] as String?;
          commentary.text = teacherCommentary ?? '';
          commentaryStudent.text = studentCommentary ?? '';
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
          } else if (days < 0 && grade != null) {
            remainingDaysText = 'Выполнено';
          } else {
            remainingDaysText = 'Просрочено';
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
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
                          horizontal: 16.0, vertical: 16.0),
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
                                      overflow: TextOverflow.visible,
                                      softWrap: true,
                                      style:
                                      figmaTextStyles.regularText.copyWith(
                                        color: FigmaColors.darkBlueMain,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Row(
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
                            text: widget.description.isNotEmpty
                                ? widget.description
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
                              String? token = await apiService.getJwtToken();
                              if (token != null && widget.taskId != null) {
                                String? filepath = await apiService
                                    .downloadTaskFile(token, widget.taskId, widget.taskLink);
                                if (filepath != null) {
                                  openFile(filepath);
                                }
                              } else {
                                print('Token or idAnswer is null');
                              }
                            },
                            child: Text(
                              widget.taskLink,
                              style: TextStyle(
                                color: FigmaColors.selectorColor,
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
                              if (token != null && idAnswer != null && fileLink != null) {
                                String? filepath = await apiService
                                    .downloadTaskAnswer(token, idAnswer!, fileLink!);
                                if (filepath != null) {
                                  openFile(filepath);
                                }
                              } else {
                                print('Token, idAnswer or fileLink is null');
                              }
                            },
                            child: Text(
                              fileLink ?? 'Пусто',
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
                            text:
                            grade != null ? '$grade' : 'Работа еще не оценена',
                            style: figmaTextStyles.regularText.copyWith(
                              color: FigmaColors.darkBlueMain,
                            ),
                          ),
                          SizedBox(height: 16),
                          CustomText(
                            text: 'Комментарий предподавателя:',
                            style: figmaTextStyles.header1Medium.copyWith(
                              color: FigmaColors.darkBlueMain,
                            ),
                          ),
                          CustomText(
                            text: commentary.text.isEmpty
                                ? 'Комментарий отсутствует'
                                : commentary.text,
                            style: figmaTextStyles.regularText.copyWith(
                              color: FigmaColors.darkBlueMain,
                            ),
                          ),
                          SizedBox(height: 16),
                          CustomText(
                            text: 'Комментарий студента:',
                            style: figmaTextStyles.header1Medium.copyWith(
                              color: FigmaColors.darkBlueMain,
                            ),
                          ),
                          CustomText(
                            text: commentaryStudent.text.isEmpty
                                ? 'Комментарий отсутствует'
                                : commentaryStudent.text,
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
                        value: grade,
                        hint: Text('Выберите оценку'),
                        items: [0, 1, 2, 3, 4, 5].map((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                        onChanged: (int? value) {
                          setState(() {
                            grade = value;
                          });
                        },
                      ),
                    ),
                  if (user.role != 'STUDENT')
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: CustomText(
                        text: "Ваш комментарий к работе",
                        style: figmaTextStyles.caption1Medium
                            .copyWith(color: FigmaColors.darkBlueMain),
                        align: TextAlign.center,
                      ),
                    ),
                  if (user.role != 'STUDENT')
                    CustomTextField(
                      hintText: '',
                      maxLines: 6,
                      controller: commentary,
                      figmaTextStyles: figmaTextStyles,
                      enabled: true,
                    ),
                  if (user.role == 'STUDENT')
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: CustomText(
                        text: "Ваш комментарий к работе",
                        style: figmaTextStyles.caption1Medium
                            .copyWith(color: FigmaColors.darkBlueMain),
                        align: TextAlign.center,
                      ),
                    ),
                  if (user.role == 'STUDENT')
                    CustomTextField(
                      hintText: '',
                      maxLines: 6,
                      controller: commentaryStudent,
                      figmaTextStyles: figmaTextStyles,
                      enabled: true,
                    ),
                  if (user.role != 'STUDENT')
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 70, vertical: 12),
                      child: CustomButton(
                        text: 'Оценить работу',
                        onPressed: () async {
                          try {
                            String? token = await apiService.getJwtToken();
                            if (token != null && idAnswer != null) {
                              print(token);
                              await apiService.updateTaskAnswer(
                                token: token,
                                id: idAnswer!,
                                taskId: widget.taskId,
                                studentUserId: widget.studentId,
                                submissionDate:
                                submissionDate?.toIso8601String() ?? '',
                                teacherCommentary: commentary.text,
                                grade: grade ?? 0,
                                fileLink: fileLink ?? '',
                                studentCommentary: studentCommentary ?? '',
                              );
                              AppRoutes.navigateToPageWithFadeTransition(
                                  context,
                                  TaskGroupViewPage(
                                    userId: widget.userId,
                                    groupId: widget.groupId,
                                    subject: widget.subject,
                                    endDate: widget.endDate,
                                    startDate: widget.startDate,
                                    teacher: widget.teacher,
                                    description: widget.description,
                                    fileLink: widget.taskLink,
                                    taskId: widget.taskId,
                                    endDateString: widget.date,
                                  ));
                              AppMetrica.reportEvent('Работа оценена');
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Работа оценена'),
                              ));
                            } else {
                              print('Token or idAnswer is null');
                            }
                          } catch (e) {
                            print('Error updating task answer: $e');
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
                            String? token = await apiService.getJwtToken();
                              String filePath = result!.files.first.path!;
                              File file = File(filePath);
                              String fileName = file.path.split('/').last;
                              await apiService.uploadTaskAnswerFile(token!, file, idAnswer!);
                                AppMetrica.reportEvent('Ответ отправлен');
                                await apiService.updateTaskAnswer(
                                  token: token,
                                  id: idAnswer!,
                                  taskId: widget.taskId,
                                  studentUserId: widget.studentId,
                                  submissionDate:
                                  submissionDate?.toIso8601String() ?? '',
                                  teacherCommentary: teacherCommentary ?? '',
                                  studentCommentary: commentaryStudent.text,
                                  grade: grade ?? 0,
                                  fileLink: '$fileName',
                                );
                                AppRoutes.navigateToPageWithFadeTransition(
                                    context,
                                    TasksPage(
                                      userId: widget.userId,
                                    ));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Работа отправлена'),
                                  ),
                                );
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

    if (remainingDays <= 0 && (grade == null || grade == 2)) {
      return Color(0xFFC76767); // Цвет C55353
    } else if (grade == 0) {
      return Color(0xFFFCEBC1); // Цвет FCEBC1
    } else if (grade != null && grade! > 2) {
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