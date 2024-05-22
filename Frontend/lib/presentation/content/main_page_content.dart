import 'package:project_pal/core/app_export.dart';

class MainPageContent extends StatefulWidget {
  final int userId;

  const MainPageContent({Key? key, required this.userId}) : super(key: key);

  @override
  _MainPageContentState createState() => _MainPageContentState();
}

class _MainPageContentState extends State<MainPageContent> {
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();

  int completedTasks = 2;
  int notCompletedTasks = 4;

  List<NotificationItem> notifications = [
    NotificationItem(
      text: 'Учитель выложил домашнее задание',
      avatarUrl: 'https://example.com/avatar1.jpg',
      isSystem: false,
    ),
    NotificationItem(
      text: 'Системное уведомление о важном событии',
      isSystem: true,
    ),
    NotificationItem(
      text: 'Ваш друг отправил вам сообщение',
      avatarUrl: 'https://example.com/avatar2.jpg',
      isSystem: false,
    ),
  ];

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Ваш кастомный AppBar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: 'Добрый день,\n' + DataUtils.getUserNameById(widget.userId),
                    style: figmaTextStyles.header2Regular.copyWith(
                      color: FigmaColors.darkBlueMain,
                    ),
                  ),
                  // Добавим иконку уведомлений
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
              SizedBox(height: 8),
              // Центрируем текст "Ваша статистика"
              Center(
                child: CustomText(
                  text: 'Ваша статистика',
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
              completedTasks: completedTasks,
              incompleteTasks: notCompletedTasks,
            ),
          ),
        ),
        SizedBox(height: 20),
        // Добавим информацию о заданиях
      ],
    );
  }
}
