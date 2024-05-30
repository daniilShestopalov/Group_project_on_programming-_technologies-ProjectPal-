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
  late String token;
  dynamic user;
  late int allTasks;
  late int notCompletedTasks;


  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    apiService = ApiService();
    final token = await apiService.getJwtToken();
    user = await apiService.getUserById(token!, widget.userId);
    int countTasks = await apiService.getTasksCountByGroup(user.groupId, token);
    int countProject = await apiService.getProjectCountByUserId(user.id, token);
    setState(() {
      allTasks = countTasks;
      notCompletedTasks = countProject;
    });
  }



  List<NotificationItem> notifications = [];

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
      return CircularProgressIndicator(); // Или другой виджет загрузки
    }

    return Column(
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
                    text: 'Здраствуйте,\n' + '${user.name}',
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
              allTasks: allTasks,
              incompleteTasks: notCompletedTasks,
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
