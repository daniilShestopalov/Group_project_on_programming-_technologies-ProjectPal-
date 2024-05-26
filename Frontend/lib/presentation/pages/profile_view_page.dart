import 'package:project_pal/core/app_export.dart';

class ProfileViewPage extends StatefulWidget {

  final int userId;

  final int userViewId;

  const ProfileViewPage({Key? key, required this.userId, required this.userViewId}) : super(key: key);

  @override
  _ProfileViewPageState createState() => _ProfileViewPageState();

}

class _ProfileViewPageState extends State<ProfileViewPage> {


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
      body: ProfileViewPageContent(userId: widget.userId, userViewId: widget.userViewId),
      bottomNavigationBar: CustomBottomBar(currentPage: 'main', userId: widget.userId,),
    );
  }
}
