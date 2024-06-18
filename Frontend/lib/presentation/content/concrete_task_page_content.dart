import 'package:project_pal/core/app_export.dart';


class ConcreteTaskPageContent extends StatefulWidget {
  final int userId;
  final String subject;
  final String date;
  final DateTime startDate;
  final String teacher;
  final String description;
  final String fileLink;
  final int taskId;

  const ConcreteTaskPageContent({
    required this.userId,
    required this.subject,
    required this.date,
    required this.startDate,
    required this.teacher,
    required this.description,
    required this.taskId,
    required this.fileLink,
  });

  @override
  _ConcreteTaskPageContentState createState() => _ConcreteTaskPageContentState();
}

class _ConcreteTaskPageContentState extends State<ConcreteTaskPageContent> {
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();
  late Future<User?> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = _fetchUser();
  }

  Future<User?> _fetchUser() async {
    ApiService apiService = ApiService();
    String? token = await apiService.getJwtToken();
    User user = await apiService.getUserById(token!, widget.userId);
    return user;
  }

  DateTime calculateDeadline(String daysDifference) {
    int days = int.parse(daysDifference);
    DateTime currentDate = DateTime.now();
    DateTime deadline = currentDate.add(Duration(days: days));

    return deadline;
  }

  void deleteTask() async {
    try {
      ApiService apiService = ApiService();
      String? token = await apiService.getJwtToken();
      await apiService.deleteTask( token:token!, taskId:widget.taskId);
      AppRoutes.navigateToPageWithFadeTransition(context, TasksPage(userId: widget.userId));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Задание удалено'),
        ),
      );
    } catch (e) {
      print('Failed to delete task: $e');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: EdgeInsets.only(top: 26),
        child: TaskBlockOpenWidget(
          subject: widget.subject,
          date: widget.date,
          teacher: widget.teacher,
          userId: widget.userId,
          instruction: widget.description,
          taskId: widget.taskId,
        ),
      ),
    ),
    floatingActionButton: FutureBuilder<User?>(
      future: _userFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(); // Можно показать заглушку или индикатор загрузки
        } else {
          if (snapshot.hasData && snapshot.data!.role != 'STUDENT') {
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: deleteTask,
                  child: Icon(Icons.delete),
                  backgroundColor: Colors.red, // Красный цвет для удаления
                ),
                SizedBox(height: 16), // Отступ между кнопками, если нужен
                FloatingActionButton(
                  onPressed: () {
                    AppRoutes.navigateToPageWithFadeTransition(
                      context,
                      TasksUpdatePage(
                        userId: widget.userId,
                        subject: widget.subject,
                        teacher: widget.teacher,
                        description: widget.description,
                        taskId: widget.taskId,
                        endDate: calculateDeadline(widget.date),
                        startDate: widget.startDate,
                        fileLink: widget.fileLink,
                      ),
                    );
                  },
                  child: Icon(Icons.create_outlined),
                  backgroundColor: FigmaColors.contrastToMain,
                ),
              ],
            );
          } else {
            return Container(); // Возвращаем пустой контейнер, если пользователь студент или произошла ошибка
          }
        }
      },
    ),
  );
}
