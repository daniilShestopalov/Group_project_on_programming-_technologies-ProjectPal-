import 'package:project_pal/core/app_export.dart';

class TasksCreatePage extends StatefulWidget {

  final int userId;
  final String subject;
  final String date;
  final String teacher;
  final String description;
  final int taskId;

  const TasksCreatePage({
    Key? key,
    required this.userId,
    required this.subject,
    required this.date,
    required this.teacher,
    required this.description,
    required this.taskId,
  }) : super(key: key);

  @override
  _TasksCreatePageState createState() => _TasksCreatePageState();
}

class _TasksCreatePageState extends State<TasksCreatePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        onMenuPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
        userId: widget.userId,
      ),
      drawer: CustomSideMenu(figmaTextStyles: FigmaTextStyles(), userId: widget.userId),
      body: TasksCreatePageContent(userId: widget.userId, subject: widget.subject, date: widget.date, teacher: widget.teacher, description: widget.description, taskId: widget.taskId,),
      bottomNavigationBar: CustomBottomBar(currentPage: '', userId: widget.userId,), // Добавляем кастомный нижний бар
    );
  }
}
