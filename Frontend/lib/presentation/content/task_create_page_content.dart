import 'package:project_pal/core/app_export.dart';

class TasksCreatePageContent extends StatefulWidget {

  final int userId;
  final String subject;
  final DateTime endDate;
  final DateTime startDate;
  final String teacher;
  final String description;
  final int taskId;
  final String fileLink;

  const TasksCreatePageContent({
    required this.userId,
    required this.subject,
    required this.endDate,
    required this.startDate,
    required this.teacher,
    required this.description,
    required this.taskId,
    required this.fileLink,
  });

  @override
  _TasksCreatePageContentState createState() => _TasksCreatePageContentState();
}

class _TasksCreatePageContentState extends State<TasksCreatePageContent> {
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Container(
      padding: EdgeInsets.only(top: 36),
      child: TaskBlockOpenCreateWidget(
        subject: widget.subject,
        teacher: widget.teacher,
        userId: widget.userId,
        instruction: widget.description,
        taskId: widget.taskId,
        endDate: widget.endDate,
        startDate: widget.startDate,
        fileLink: widget.fileLink,
      ),
    ),
  );
}
