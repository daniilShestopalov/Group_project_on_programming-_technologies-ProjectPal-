import 'package:project_pal/core/app_export.dart';

class MainPageContent extends StatefulWidget {
  final int userId;

  const MainPageContent({Key? key, required this.userId}) : super(key: key);

  @override
  _MainPageContentState createState() => _MainPageContentState();
}

class _MainPageContentState extends State<MainPageContent> {
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();
  late ApiService apiService;
  String? token;
  dynamic user;
  int? allTasks;
  int? notCompletedTasks;
  List<NotificationItem> notifications = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    apiService = ApiService();
    token = await apiService.getJwtToken();
    user = await apiService.getUserById(token!, widget.userId);

    int countTasks = 0;
    int countProject = 0;
    DateTime currentDate = DateTime.now();

    if (user.role == 'STUDENT') {
      countTasks = await apiService.getTasksCountByGroup(user.groupId, token!);
      countProject = await apiService.getProjectCountByUserId(user.id, token!);
      List<Tasks> tasks = await apiService.getTasksByMonthAndGroup(user.groupId, currentDate.year,
        currentDate.month, token!);
      List<Project> projects = await apiService.getProjectsByStudentIdAndMonth(user.id, currentDate.year, currentDate.month, token!);

      notifications = _generateNotifications(tasks, projects);
    } else {
      countTasks = await apiService.getTasksCountByTeacherId(user.id, token!);
      countProject = await apiService.getProjectsCountByTeacherId(user.id, token!);

    }

    setState(() {
      allTasks = countTasks;
      notCompletedTasks = countProject;
    });
  }

  List<NotificationItem> _generateNotifications(List<Tasks> tasks, List<Project> projects) {
    List<NotificationItem> notifications = [];
    DateTime now = DateTime.now();

    for (Tasks task in tasks) {
      Duration difference = task.endDate.difference(now);
      String timeLeft = _formatDuration(difference);
      notifications.add(NotificationItem(
        text: 'Осталось $timeLeft времени до сдачи задачи "${task.name}"',
        avatarUrl: null,
        isSystem: true,
      ));
    }

    for (Project project in projects) {
      Duration difference = project.endDate.difference(now);
      String timeLeft = _formatDuration(difference);
      notifications.add(NotificationItem(
        text: 'Осталось $timeLeft времени до сдачи проекта "${project.name}"',
        avatarUrl: null,
        isSystem: true,
      ));
    }

    return notifications;
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays} дней';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} часов';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} минут';
    } else {
      return 'меньше минуты';
    }
  }

  void _showNotifications() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomNotification(notifications: notifications);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: 'Здравствуйте,\n' + '${user.name}',
                      style: figmaTextStyles.header2Regular.copyWith(
                        color: FigmaColors.darkBlueMain,
                      ),
                    ),
                    Stack(
                      children: [
                        IconButton(
                          icon: Icon(Icons.notifications, color: FigmaColors.darkBlueMain, size: 28),
                          onPressed: _showNotifications,
                        ),
                        if (notifications.isNotEmpty)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              constraints: BoxConstraints(
                                minWidth: 24,
                                minHeight: 24,
                              ),
                              child: Center(
                                child: Text(
                                  '${notifications.length}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Center(
                  child: CustomText(
                    text: 'Статистика',
                    style: figmaTextStyles.header1Medium.copyWith(
                      color: FigmaColors.darkBlueMain,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Используем CustomPieChart для отображения круговой диаграммы
          Container(
            child: Center(
              child: CustomPieChart(
                allTasks: allTasks ?? 0,
                incompleteTasks: notCompletedTasks ?? 0,
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
