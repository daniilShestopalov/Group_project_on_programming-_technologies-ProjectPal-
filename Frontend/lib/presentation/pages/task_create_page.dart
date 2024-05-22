import 'package:project_pal/core/app_export.dart';

class TasksCreatePage extends StatefulWidget {

  final int userId;

  const TasksCreatePage({Key? key, required this.userId}) : super(key: key);

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
      body: TasksCreatePageContent(userId: widget.userId),
      bottomNavigationBar: CustomBottomBar(currentPage: '', userId: widget.userId,), // Добавляем кастомный нижний бар
    );
  }
}
