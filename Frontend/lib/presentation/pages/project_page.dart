import 'package:project_pal/core/app_export.dart';

class ProjectPage extends StatefulWidget {

  final int userId;

  const ProjectPage({Key? key, required this.userId}) : super(key: key);

  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
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
      body: ProjectPageContent(userId: widget.userId),
      bottomNavigationBar: CustomBottomBar(currentPage: 'project', userId: widget.userId,), // Добавляем кастомный нижний бар
    );
  }
}
