import 'package:project_pal/core/app_export.dart';

class ConcreteProjectPage extends StatefulWidget {

  final int userId;
  final String subject;
  final String date;
  final DateTime startDate;
  final DateTime endDate;
  final String teacher;
  final String description;
  final String fileLink;
  final int taskId;

  const ConcreteProjectPage({
    Key? key,
    required this.userId,
    required this.subject,
    required this.date,
    required this.startDate,
    required this.teacher,
    required this.description,
    required this.taskId,
    required this.fileLink,
    required this.endDate,
  }) : super(key: key);

  @override
  _ConcreteProjectState createState() => _ConcreteProjectState();
}

class _ConcreteProjectState extends State<ConcreteProjectPage> {
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
      body: ConcreteProjectPageContent(
        userId: widget.userId,
        subject: widget.subject,
        date: widget.date,
        teacher: widget.teacher,
        description: widget.description,
        taskId: widget.taskId,
        fileLink: widget.fileLink,
        startDate: widget.startDate,
        endDate: widget.endDate,
      ),
      bottomNavigationBar: CustomBottomBar(currentPage: 'project', userId: widget.userId,), // Добавляем кастомный нижний бар
    );
  }
}
