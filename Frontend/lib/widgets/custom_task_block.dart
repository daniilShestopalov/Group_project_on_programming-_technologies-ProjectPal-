import 'package:project_pal/core/app_export.dart';

class TaskBlockWidget extends StatefulWidget {
  final String subject;
  final DateTime endDate;
  final String teacher;
  final int userId;
  final String description;
  final int taskId;

  TaskBlockWidget({
    required this.subject,
    required this.endDate,
    required this.teacher,
    required this.userId,
    required this.description,
    required this.taskId,
  });

  @override
  _TaskBlockWidgetState createState() => _TaskBlockWidgetState();
}

class _TaskBlockWidgetState extends State<TaskBlockWidget> {
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();
  final ApiService apiService = ApiService();
  int? teacherGrade;

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
          teacherGrade = data[0]['grade'];
        });
      } else {
        teacherGrade = null;
      }
    } catch (e) {
      print('Failed to load task answer: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    int difference = widget.endDate.difference(now).inDays;
    String endDate = difference.toString();

    String remainingDaysText = '';
    if (difference < 0 && teacherGrade == null) {
      remainingDaysText = 'Просрочено';
    } else if (difference < 0 && teacherGrade != null) {
      remainingDaysText = 'Выполнено';
    } else if (difference == 0) {
      remainingDaysText = 'Сегодня';
    } else if (difference == 1) {
      remainingDaysText = '$difference день';
    } else if (difference > 1 && difference < 5) {
      remainingDaysText = '$difference дня';
    } else {
      remainingDaysText = '$difference дней';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: () {
          AppRoutes.navigateToPageWithFadeTransition(
            context,
            ConcreteTaskPage(
              userId: widget.userId,
              subject: widget.subject,
              date: endDate,
              teacher: widget.teacher,
              description: widget.description,
              taskId: widget.taskId,
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: FigmaColors.contrastToMain,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: FigmaColors.darkBlueMain,
                offset: Offset(0, 6),
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
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: widget.subject,
                              style: figmaTextStyles.header2Medium.copyWith(
                                color: FigmaColors.darkBlueMain,
                              ),
                            ),
                            CustomText(
                              text: widget.teacher,
                              style: figmaTextStyles.caption1Regular.copyWith(
                                color: FigmaColors.darkBlueMain,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: CustomText(
                                text: widget.description,
                                style: figmaTextStyles.regularText.copyWith(
                                  color: FigmaColors.darkBlueMain,
                                ),
                              ),
                            ),
                          ],
                        ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
