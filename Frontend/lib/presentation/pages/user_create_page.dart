import 'package:project_pal/core/app_export.dart';

class UserCreatePage extends StatefulWidget {

  final int userId;

  const UserCreatePage({Key? key, required this.userId}) : super(key: key);

  @override
  _UserCreateState createState() => _UserCreateState();

}

class _UserCreateState extends State<UserCreatePage> {


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
      body: UserCreatePageContent(userId: widget.userId),
      bottomNavigationBar: CustomBottomBar(currentPage: '', userId: widget.userId,),
    );
  }
}
