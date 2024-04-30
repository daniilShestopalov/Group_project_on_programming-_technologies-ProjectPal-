import 'package:project_pal/core/app_export.dart';

class ProfessorPage extends StatefulWidget {

  final int userId;

  const ProfessorPage({Key? key, required this.userId}) : super(key: key);

  @override
  _ProfessorPageState createState() => _ProfessorPageState();

}

class _ProfessorPageState extends State<ProfessorPage> {


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
      body: ProfessorPageContent(userId: widget.userId),
      bottomNavigationBar: CustomBottomBar(currentPage: 'main', userId: widget.userId,),
    );
  }
}
