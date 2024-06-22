import 'package:project_pal/core/app_export.dart';

class StudentsPage extends StatefulWidget {

  final int userId;

  const StudentsPage({Key? key, required this.userId}) : super(key: key);

  @override
  _StudentsPageState createState() => _StudentsPageState();

}

class _StudentsPageState extends State<StudentsPage> {


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
      body: StudentsPageContent(userId: widget.userId),
      bottomNavigationBar: CustomBottomBar(currentPage: 'main', userId: widget.userId,),
    );
  }
}
