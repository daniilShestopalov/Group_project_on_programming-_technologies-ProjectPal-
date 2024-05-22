import 'package:project_pal/core/app_export.dart';

class ComplaintPage extends StatefulWidget {

  final int userId;

  const ComplaintPage({Key? key, required this.userId}) : super(key: key);

  @override
  _ComplaintPageState createState() => _ComplaintPageState();

}

class _ComplaintPageState extends State<ComplaintPage> {


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
      body: ComplaintPageContent(userId: widget.userId),
      bottomNavigationBar: CustomBottomBar(currentPage: 'main', userId: widget.userId,),
    );
  }
}
