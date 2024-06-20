import 'package:flutter/material.dart';
import 'package:project_pal/core/app_export.dart';

class ConcreteProjectPageContent extends StatefulWidget {
  final int userId;
  final String subject;
  final String date;
  final String teacher;
  final String description;
  final int taskId;
  final String fileLink;
  final DateTime startDate;
  final DateTime endDate;

  const ConcreteProjectPageContent({
    required this.userId,
    required this.subject,
    required this.date,
    required this.teacher,
    required this.description,
    required this.taskId,
    required this.fileLink,
    required this.startDate,
    required this.endDate,
  });

  @override
  _ConcreteProjectPageContentState createState() =>
      _ConcreteProjectPageContentState();
}

class _ConcreteProjectPageContentState
    extends State<ConcreteProjectPageContent> {
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();

  void deleteTask() async {
    try {
      ApiService apiService = ApiService();
      String? token = await apiService.getJwtToken();
      if (token == null) {
        throw Exception("Failed to get token");
      }
      await apiService.deleteProject(token: token, taskId: widget.taskId);
      AppRoutes.navigateToPageWithFadeTransition(context, ProjectPage(userId: widget.userId));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Проект удален'),
        ),
      );
    } catch (e) {
      print('Failed to delete task: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: EdgeInsets.only(top: 26),
          child: ProjectBlockOpenWidget(
            subject: widget.subject,
            date: widget.date,
            teacher: widget.teacher,
            userId: widget.userId,
            description: widget.description,
            taskId: widget.taskId,
            taskLink: widget.fileLink,
            startDate: widget.startDate,
            endDate: widget.endDate,
          ),
        ),
      ),
      floatingActionButton: Column(
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
                ProjectUpdatePage(
                  userId: widget.userId,
                  subject: widget.subject,
                  teacher: widget.teacher,
                  description: widget.description,
                  taskId: widget.taskId,
                  endDate: widget.endDate,
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
      ),
    );
  }
}
