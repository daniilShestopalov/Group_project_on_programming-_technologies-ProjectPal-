import 'package:project_pal/core/app_export.dart';

class CustomTaskGroupListViewBlock extends StatefulWidget {
  final int userId;
  final User user;
  final Group group;
  final String subject;
  final DateTime endDate;
  final DateTime startDate;
  final String teacher;
  final String description;
  final String fileLink;
  final int taskId;
  final String endDateString;

  const CustomTaskGroupListViewBlock({
    Key? key,
    required this.userId,
    required this.user,
    required this.group,
    required this.subject,
    required this.endDate,
    required this.startDate,
    required this.teacher,
    required this.description,
    required this.fileLink,
    required this.taskId,
    required this.endDateString,
  }) : super(key: key);

  @override
  _CustomTaskGroupListViewBlockState createState() => _CustomTaskGroupListViewBlockState();
}

class _CustomTaskGroupListViewBlockState extends State<CustomTaskGroupListViewBlock> {
  late ApiService apiService;
  int? studentId;
  FigmaTextStyles figmaTextStyles = FigmaTextStyles();
  String? statusText;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    _loadTaskAnswers();
  }

  Future<void> _loadTaskAnswers() async {
    try {
      String token = await apiService.getJwtToken() ?? '';
      Map<String, dynamic> data =
      await apiService.getTaskAnswerByTaskIdAndStudentId(token, widget.taskId, widget.user.id);
      print('Data for student ${widget.user.id}: $data'); // Отладочное сообщение

      setState(() {
        if (data.isNotEmpty) {
          int teacherGrade = data['grade'];
          String answerLink = data['fileLink'] ?? '';
          if (answerLink.isNotEmpty && teacherGrade == 0) {
            statusText = 'Ответ выложен';
          } else if (teacherGrade > 0) {
            statusText = 'Работа оценена';
          } else {
            statusText = 'В работе';
          }
        } else {
          statusText = 'Нет данных'; // Установка значения по умолчанию, если данных нет
        }
      });
    } catch (e) {
      print('Failed to load task answer for student ${widget.user.id}: $e'); // Отладочное сообщение
    }
  }



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppRoutes.navigateToPageWithFadeTransition(
          context,
          ConcreteTaskPage(
            userId: widget.userId,
            subject: widget.subject,
            date: widget.endDateString,
            teacher: widget.teacher,
            description: widget.description,
            taskId: widget.taskId,
            startDate: widget.startDate,
            endDate: widget.endDate,
            fileLink: widget.fileLink,
            studentID: widget.user.id,
            groupId: widget.group.id,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFC6D8DE),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CustomText(
                  text: 'Студент: ${widget.user.surname} ${widget.user.name} ${widget.user.patronymic}',
                  style: figmaTextStyles.regularText.copyWith(
                    color: FigmaColors.darkBlueMain,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CustomText(
                    text: 'Статус: $statusText', // Используем определенный статус текста
                    style: figmaTextStyles.regularText.copyWith(
                      color: FigmaColors.darkBlueMain,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
