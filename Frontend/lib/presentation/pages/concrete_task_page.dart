import 'package:project_pal/core/app_export.dart';

class ConcreteTaskPage extends StatefulWidget {

  final int userId;
  final String subject;
  final String date;
  final DateTime startDate;
  final String teacher;
  final String description;
  final String fileLink;
  final int taskId;

  const ConcreteTaskPage({
    Key? key,
    required this.userId,
    required this.subject,
    required this.date,
    required this.startDate,
    required this.teacher,
    required this.description,
    required this.taskId,
    required this.fileLink,
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
      body: ConcreteTaskPageContent(
        userId: widget.userId,
        subject: widget.subject,
        date: widget.date,
        teacher: widget.teacher,
        description: widget.description,
        taskId: widget.taskId,
        startDate: widget.startDate,
        fileLink: widget.fileLink,
      ),
      bottomNavigationBar: CustomBottomBar(currentPage: 'task', userId: widget.userId,), // Добавляем кастомный нижний бар
    );
  }
}
