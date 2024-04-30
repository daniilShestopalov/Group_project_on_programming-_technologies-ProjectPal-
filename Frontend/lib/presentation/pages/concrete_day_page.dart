import 'package:project_pal/core/app_export.dart';

class ConcreteDayPage extends StatefulWidget {

  final int userId;
  final List<Map<String, dynamic>> tasks;
  final DateTime selectedDate;

  const ConcreteDayPage({Key? key, required this.userId, required this.tasks, required this.selectedDate, }) : super(key: key);

  @override
  _ConcreteDayState createState() => _ConcreteDayState();
}

class _ConcreteDayState extends State<ConcreteDayPage> {
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
      body: DataUtils.getUserRoleById(widget.userId) == 'student' ? ConcreteDayPageContent(userId: widget.userId, tasks: widget.tasks, selectedDate: widget.selectedDate,) : null,
      bottomNavigationBar: CustomBottomBar(currentPage: '', userId: widget.userId,), // Добавляем кастомный нижний бар
    );
  }
}
