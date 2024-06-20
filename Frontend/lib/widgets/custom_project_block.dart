import 'package:project_pal/core/app_export.dart';

class ProjectBlockWidget extends StatefulWidget {
  final String role;
  final String subject;
  final DateTime endDate;
  final DateTime startDate;
  final String teacher;
  final int userId;
  final String description;
  final String fileLink;
  final int projectId;

  ProjectBlockWidget({
    required this.subject,
    required this.endDate,
    required this.startDate,
    required this.teacher,
    required this.userId,
    required this.description,
    required this.projectId,
    required this.fileLink,
    required this.role,
  });

  @override
  _ProjectBlockWidgetState createState() => _ProjectBlockWidgetState();
}

class _ProjectBlockWidgetState extends State<ProjectBlockWidget> {
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();
  final ApiService apiService = ApiService();
  int? teacherGrade;
  bool isLoading = true;
  int? studentId;

  @override
  void initState() {
    super.initState();
    _loadTaskAnswer();
  }

  Future<void> _loadTaskAnswer() async {
    try {
      String token = await apiService.getJwtToken() ?? '';
      final Map<String, dynamic> data =
      await apiService.getProjectAnswerByProjectId(token, widget.projectId);
      if (data.isNotEmpty) {
        setState(() {
          studentId = data['studentUserId'];
          teacherGrade = data['grade'];


        });
      } else {
        teacherGrade = null;
      }
    } catch (e) {
      print('Failed to load task answer: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    DateTime now = DateTime.now();
    print(widget.endDate);
    print('дней');
    int difference = widget.endDate.difference(now).inDays;
    print(difference);
    String endDate = difference.toString();
    print(endDate);

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
          if(widget.role == 'STUDENT') {
            AppRoutes.navigateToPageWithFadeTransition(
                context,
                ConcreteProjectPage(
                  userId: widget.userId,
                  subject: widget.subject,
                  date: endDate,
                  teacher: widget.teacher,
                  description: widget.description,
                  taskId: widget.projectId,
                  startDate: widget.startDate,
                  fileLink: widget.fileLink,
                  endDate: widget.endDate,
                ));
          } else {
            AppRoutes.navigateToPageWithFadeTransition(
                context,
                ConcreteProjectPage(
                  userId: widget.userId,
                  subject: widget.subject,
                  endDate: widget.endDate,
                  startDate: widget.startDate,
                  teacher: widget.teacher,
                  description: widget.description,
                  fileLink: widget.fileLink,
                  taskId: widget.projectId,
                  date: endDate,
                ));
          }

        },
        child: Container(
          decoration: BoxDecoration(
            color: getBackgroundColor(teacherGrade),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                offset: Offset(0, 5),
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

  Color getBackgroundColor(int? teacherGrade) {
    DateTime now = DateTime.now();
    int difference = widget.endDate.difference(now).inDays;
    if (difference >= 0 && teacherGrade == null || teacherGrade == 0) {
      return FigmaColors.editTask; // Желтый цвет для пустого значения
    } else if (teacherGrade == 2 || (difference < 0 && teacherGrade == null)) {
      return FigmaColors.lightRedMain; // Красный цвет для значения 2
    } else {
      return FigmaColors.greenGrade; // Зеленый цвет для значений 3, 4 и 5
    }
  }
}
