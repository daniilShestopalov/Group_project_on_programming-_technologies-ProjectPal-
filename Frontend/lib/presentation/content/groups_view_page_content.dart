import 'package:project_pal/core/app_export.dart';

class GroupsViewPageContent extends StatefulWidget {
  final int userId;
  final Group group;

  const GroupsViewPageContent({Key? key, required this.userId, required this.group}) : super(key: key);

  @override
  _GroupsViewPageContentState createState() => _GroupsViewPageContentState();
}

class _GroupsViewPageContentState extends State<GroupsViewPageContent> {
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();
  final ApiService apiService = ApiService();

  SortOrder sortOrder = SortOrder.ascending;
  int selectedIndex = 0;

  List<int> studentUserIds = [];
  List<User> students = [];

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    try {
      final token = await apiService.getJwtToken();
      final loadedStudents = await apiService.getUsersByGroup(widget.group.id, token!);

      setState(() {
        students = loadedStudents;
        studentUserIds = students.map((student) => student.id).toList();
      });
    } catch (error) {
      print('Error loading students: $error');
    }
  }

  void _sortStudentsByFullName() {
    setState(() {
      if (sortOrder == SortOrder.ascending) {
        students.sort((a, b) => a.surname.compareTo(b.surname));
        sortOrder = SortOrder.descending;
      } else {
        students.sort((a, b) => b.surname.compareTo(a.surname));
        sortOrder = SortOrder.ascending;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Блок 1
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Center(
                      child: CustomText(
                    text: 'Группа ${widget.group.groupNumber}',
                    style: figmaTextStyles.header1Medium.copyWith(
                      color: FigmaColors.darkBlueMain,
                    ), align: TextAlign.center,
                  ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.sort_by_alpha),
                    onPressed: _sortStudentsByFullName,
                  ),
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
        // Блок 2
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              itemCount: studentUserIds.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: CustomGroupListViewBlock(
                    userId: widget.userId,
                    user: students[index],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
