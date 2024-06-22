import 'package:project_pal/core/app_export.dart';

class GroupUpdatePage extends StatefulWidget {
  final int userId;
  final int groupId;

  const GroupUpdatePage({
    Key? key,
    required this.userId,
    required this.groupId,
  }) : super(key: key);

  @override
  _GroupUpdatePageState createState() => _GroupUpdatePageState();
}

class _GroupUpdatePageState extends State<GroupUpdatePage> {
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
      body: GroupUpdatePageContent(userId: widget.userId, groupId: widget.groupId),
      bottomNavigationBar: CustomBottomBar(
        currentPage: '',
        userId: widget.userId,
      ), // Добавляем кастомный нижний бар
    );
  }
}
