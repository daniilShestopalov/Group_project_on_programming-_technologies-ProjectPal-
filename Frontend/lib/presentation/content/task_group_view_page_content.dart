import 'package:project_pal/core/app_export.dart';

class TaskGroupViewPageContent extends StatefulWidget {
  final int groupId;
  final String subject;
  final DateTime endDate;
  final DateTime startDate;
  final String teacher;
  final int userId;
  final String description;
  final String fileLink;
  final int taskId;
  final String endDateString;

  const TaskGroupViewPageContent(
      {Key? key,
        required this.userId,
        required this.groupId,
        required this.subject,
        required this.endDate,
        required this.startDate,
        required this.teacher,
        required this.description,
        required this.fileLink,
        required this.taskId,
        required this.endDateString})
      : super(key: key);

  @override
  _TaskGroupViewPageContentState createState() =>
      _TaskGroupViewPageContentState();
}

class _TaskGroupViewPageContentState extends State<TaskGroupViewPageContent> {
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();
  final ApiService apiService = ApiService();

  int? teacherGrade;
  String? answerLink;
  String statusText = '';
  SortOrder sortOrder = SortOrder.ascending;
  int selectedIndex = 0;

  Future<Map<String, dynamic>> _loadStudents() async {
    final token = await apiService.getJwtToken();
    final group = await apiService.getGroupById(token!, widget.groupId);
    final students = await apiService.getUsersByGroup(widget.groupId, token);

    return {'group': group, 'students': students};
  }

  void _sortStudentsByFullName(List<User> students) {
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
    return FutureBuilder<Map<String, dynamic>>(
      future: _loadStudents(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading data'));
        } else {
          final group = snapshot.data!['group'] as Group;
          final students = snapshot.data!['students'] as List<User>;

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
                              text: 'Группа ${group.groupNumber}',
                              style: figmaTextStyles.header1Medium.copyWith(
                                color: FigmaColors.darkBlueMain,
                              ),
                              align: TextAlign.center,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.sort_by_alpha),
                          onPressed: () => _sortStudentsByFullName(students),
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
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: CustomTaskGroupListViewBlock(
                          userId: widget.userId,
                          user: students[index],
                          group: group,
                          subject: widget.subject,
                          endDate: widget.endDate,
                          startDate: widget.startDate,
                          teacher: widget.teacher,
                          description: widget.description,
                          fileLink: widget.fileLink,
                          taskId: widget.taskId,
                          endDateString: widget.endDateString,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
