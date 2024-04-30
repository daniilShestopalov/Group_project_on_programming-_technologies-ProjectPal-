import 'package:project_pal/core/app_export.dart';

class GroupsViewPage extends StatefulWidget {

  final int userId;
  final String groupNumber;

  const GroupsViewPage({Key? key, required this.userId, required this.groupNumber}) : super(key: key);

  @override
  _GroupsViewPageState createState() => _GroupsViewPageState();

}

class _GroupsViewPageState extends State<GroupsViewPage> {


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
      body: GroupsViewPageContent(userId: widget.userId, groupNumber: widget.groupNumber,),
      bottomNavigationBar: CustomBottomBar(currentPage: 'main', userId: widget.userId,),
    );
  }
}
