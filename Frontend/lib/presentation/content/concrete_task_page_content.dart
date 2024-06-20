import 'package:project_pal/core/app_export.dart';

class ConcreteTaskPageContent extends StatefulWidget {
  final int userId;
  final String subject;
  final String date;
  final DateTime startDate;
  final DateTime endDate;
  final String teacher;
  final String description;
  final String fileLink;
  final int groupId;
  final int taskId;
  final int studentId;

  const ConcreteTaskPageContent({
    required this.userId,
    required this.subject,
    required this.date,
    required this.startDate,
    required this.teacher,
    required this.description,
    required this.taskId,
    required this.fileLink,
    required this.studentId,
    required this.groupId, required this.endDate,
  });

  @override
  _ConcreteTaskPageContentState createState() => _ConcreteTaskPageContentState();
}

class _ConcreteTaskPageContentState extends State<ConcreteTaskPageContent> {
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();
  late Future<User?> _userFuture;
  User? student;

  @override
  void initState() {
    super.initState();
    _userFuture = _fetchUser();
  }

  Future<User?> _fetchUser() async {
    try {
      ApiService apiService = ApiService();
      String? token = await apiService.getJwtToken();
      if (token == null) {
        throw Exception("Failed to get token");
      }
      User user = await apiService.getUserById(token, widget.userId);
      setState(() {
        student = user;
      });
      return user;
    } catch (e) {
      print('Failed to fetch user: $e');
      return null;
    }
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
      if (token == null) {
        throw Exception("Failed to get token");
      }
      await apiService.deleteTask(token: token, taskId: widget.taskId);
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
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(right: 16, left: 16, top: 16, bottom: 100),
        child: Container(
          padding: EdgeInsets.only(top: 26),
          child: FutureBuilder<User?>(
            future: _userFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Ошибка загрузки данных'));
              } else if (snapshot.hasData) {
                return TaskBlockOpenWidget(
                  subject: widget.subject,
                  date: widget.date,
                  teacher: widget.teacher,
                  userId: widget.userId,
                  description: widget.description,
                  taskId: widget.taskId,
                  taskLink: widget.fileLink,
                  studentId: widget.studentId,
                  groupId: widget.groupId, startDate: widget.startDate, endDate: widget.endDate,
                );
              } else {
                return Center(child: Text('Данные не найдены'));
              }
            },
          ),
        ),
      ),
    ),
    floatingActionButton: FutureBuilder<User?>(
      future: _userFuture,
      builder: (context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Показываем индикатор загрузки
        } else if (snapshot.hasData && snapshot.data!.role != 'STUDENT') {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FloatingActionButton(
                onPressed: deleteTask,
                child: Icon(Icons.delete),
                backgroundColor: Colors.red,
              ),
              SizedBox(height: 16),
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
              SizedBox(height: 30)
            ],
          );
        } else {
          // Если нет данных или роль 'STUDENT', показываем пустой контейнер или другое состояние
          return Container();
        }
      },
    ),
  );
}
