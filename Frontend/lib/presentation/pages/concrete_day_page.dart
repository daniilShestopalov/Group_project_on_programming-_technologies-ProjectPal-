import 'package:project_pal/core/app_export.dart';

class ConcreteDayPage extends StatefulWidget {

  final int userId;
  final DateTime selectedDate;
  final List<int> taskIds;

  const ConcreteDayPage({Key? key, required this.userId, required this.selectedDate, required this.taskIds}) : super(key: key);

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
      body: ConcreteDayPageContent(userId: widget.userId, selectedDate: widget.selectedDate, taskIds: widget.taskIds, ),
      bottomNavigationBar: CustomBottomBar(currentPage: '', userId: widget.userId,), // Добавляем кастомный нижний бар
    );
  }
}
