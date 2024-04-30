import 'package:project_pal/core/app_export.dart';

class GroupsPage extends StatefulWidget {

  final int userId;

  const GroupsPage({Key? key, required this.userId}) : super(key: key);

  @override
  _GroupsPageState createState() => _GroupsPageState();

}

class _GroupsPageState extends State<GroupsPage> {


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
      body: GroupsPageContent(userId: widget.userId),
      bottomNavigationBar: CustomBottomBar(currentPage: 'main', userId: widget.userId,),
    );
  }
}
