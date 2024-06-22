import 'package:project_pal/core/app_export.dart';

class TasksPage extends StatefulWidget {

  final int userId;

  const TasksPage({Key? key, required this.userId}) : super(key: key);

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
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
      body: TasksPageContent(userId: widget.userId),
      bottomNavigationBar: CustomBottomBar(currentPage: 'task', userId: widget.userId,), // Добавляем кастомный нижний бар
    );
  }
}
