import 'package:project_pal/core/app_export.dart';

class TasksCreatePageContent extends StatefulWidget {

  final int userId;

  const TasksCreatePageContent({
    required this.userId,
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
      padding: EdgeInsets.only(bottom: 16),
      child: TaskBlockOpenCreateWidget(
        subject: '',
        date: '',
        teacher: '',
        tasks: [],
        userId: widget.userId,
        instruction: '',
      ),
    ),
  );
}
