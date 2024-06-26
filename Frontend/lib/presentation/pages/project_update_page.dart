import 'package:project_pal/core/app_export.dart';

class ProjectUpdatePage extends StatefulWidget {
  final int userId;
  final String subject;
  final DateTime endDate;
  final DateTime startDate;
  final String teacher;
  final String description;
  final String fileLink;
  final int taskId;

  const ProjectUpdatePage({
    Key? key,
    required this.userId,
    required this.subject,
    required this.endDate,
    required this.startDate,
    required this.teacher,
    required this.description,
    required this.fileLink,
    required this.taskId,
  }) : super(key: key);

  @override
  _ProjectUpdatePageState createState() => _ProjectUpdatePageState();
}

class _ProjectUpdatePageState extends State<ProjectUpdatePage> {
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
      drawer: CustomSideMenu(
          figmaTextStyles: FigmaTextStyles(), userId: widget.userId),
      body: ProjectUpdatePageContent(
        userId: widget.userId,
        subject: widget.subject,
        teacher: widget.teacher,
        description: widget.description,
        taskId: widget.taskId,
        endDate: widget.endDate,
        startDate: widget.startDate,
        fileLink: widget.fileLink,
      ),
      bottomNavigationBar: CustomBottomBar(
        currentPage: '',
        userId: widget.userId,
      ), // Добавляем кастомный нижний бар
    );
  }
}
