import 'package:flutter/material.dart';
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
      await apiService.deleteTask(token: token!, taskId: widget.taskId);
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
          child: TaskBlockOpenWidget(
            subject: widget.subject,
            date: widget.date,
            teacher: widget.teacher,
            userId: widget.userId,
            instruction: widget.description,
            taskId: widget.taskId,
            taskLink: widget.fileLink,
            studentId: widget.studentId,
          ),
        ),
      ),
    ),
    floatingActionButton: FutureBuilder<User?>(
      future: _userFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(); // Placeholder or loading indicator
        } else {
          if (snapshot.hasData && snapshot.data!.role != 'STUDENT') {
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
                SizedBox(height: 30,)
              ],
            );
          } else {
            return Container(); // Return empty container for students or error cases
          }
        }
      },
    ),
  );
}
