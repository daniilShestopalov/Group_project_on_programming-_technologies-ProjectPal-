import 'package:project_pal/core/app_export.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        onMenuPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
        onProfilePressed: () {
        },
      ),
      drawer: CustomSideMenu(figmaTextStyles: FigmaTextStyles()),
      body: MainPageContent(),
      bottomNavigationBar: CustomBottomBar(currentPage: 'main',), // Добавляем кастомный нижний бар
    );
  }
}
