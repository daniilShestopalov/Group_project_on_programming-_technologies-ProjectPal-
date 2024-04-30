import 'package:project_pal/core/app_export.dart';

class ConcreteTaskPage extends StatefulWidget {

  final int userId;
  final String subject;
  final String date;
  final String teacher;
  final List<Task> tasks;

  const ConcreteTaskPage({
    Key? key,
    required this.userId,
    required this.subject,
    required this.date,
    required this.teacher,
    required this.tasks
  }) : super(key: key);

  @override
  _ConcreteTaskState createState() => _ConcreteTaskState();
}

class _ConcreteTaskState extends State<ConcreteTaskPage> {
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
      body: DataUtils.getUserRoleById(widget.userId) == 'student' ? ConcreteTaskPageContent(
        userId: widget.userId,
        subject: widget.subject,
        date: widget.date,
        teacher: widget.teacher,
        tasks: widget.tasks
      ) : null,
      bottomNavigationBar: CustomBottomBar(currentPage: 'task', userId: widget.userId,), // Добавляем кастомный нижний бар
    );
  }
}
