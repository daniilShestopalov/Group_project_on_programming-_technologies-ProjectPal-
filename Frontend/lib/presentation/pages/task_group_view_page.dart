import 'package:project_pal/core/app_export.dart';

class TaskGroupViewPage extends StatefulWidget {
  final Group group;
  final String subject;
  final DateTime endDate;
  final DateTime startDate;
  final String teacher;
  final int userId;
  final String description;
  final String fileLink;
  final int taskId;
  final String endDateString;

  const TaskGroupViewPage({
    Key? key,
    required this.userId,
    required this.group,
    required this.subject,
    required this.endDate,
    required this.startDate,
    required this.teacher,
    required this.description,
    required this.fileLink,
    required this.taskId,
    required this.endDateString,
  }) : super(key: key);

  @override
  _TaskGroupViewPageState createState() => _TaskGroupViewPageState();
}

class _TaskGroupViewPageState extends State<TaskGroupViewPage> {
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
      body: TaskGroupViewPageContent(
        userId: widget.userId,
        group: widget.group,
        subject: widget.subject,
        endDate: widget.endDate,
        startDate: widget.startDate,
        teacher: widget.teacher,
        description: widget.description,
        fileLink: widget.fileLink,
        taskId: widget.taskId,
        endDateString: widget.endDateString,
      ),
      bottomNavigationBar: CustomBottomBar(
        currentPage: '',
        userId: widget.userId,
      ),
    );
  }
}
