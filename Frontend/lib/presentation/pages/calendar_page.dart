import 'package:project_pal/core/app_export.dart';

class CalendarPage extends StatefulWidget {

  final int userId;

  const CalendarPage({Key? key, required this.userId}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
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
      body: CalendarPageContent(userId: widget.userId),
      bottomNavigationBar: CustomBottomBar(currentPage: 'calendar', userId: widget.userId,), // Добавляем кастомный нижний бар
    );
  }
}
