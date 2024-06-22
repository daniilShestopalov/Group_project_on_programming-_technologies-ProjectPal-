import 'package:project_pal/core/app_export.dart';

class GroupCreatePage extends StatefulWidget {
  final int userId;

  const GroupCreatePage({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  _GroupCreatePageState createState() => _GroupCreatePageState();
}

class _GroupCreatePageState extends State<GroupCreatePage> {
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
      body: GroupCreatePageContent(userId: widget.userId,),
      bottomNavigationBar: CustomBottomBar(
        currentPage: '',
        userId: widget.userId,
      ), // Добавляем кастомный нижний бар
    );
  }
}
