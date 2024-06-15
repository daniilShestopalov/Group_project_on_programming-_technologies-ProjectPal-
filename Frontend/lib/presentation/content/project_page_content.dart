import 'package:project_pal/core/app_export.dart';

class ProjectPageContent extends StatefulWidget {
  final int userId;

  const ProjectPageContent({Key? key, required this.userId}) : super(key: key);

  @override
  _ProjectPageContentState createState() => _ProjectPageContentState();
}

class _ProjectPageContentState extends State<ProjectPageContent> {
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();
  final ApiService apiService = ApiService();
  SortOrder sortOrder = SortOrder.ascending;
  Future<User>? _userFuture;
  int selectedIndex = 0;
  List<ProjectBlockWidget> projectBlocks = [];

  @override
  void initState() {
    super.initState();
    _userFuture = _initializeData();
    fetchTasks();
  }

  Future<User> _initializeData() async {
    final token = await apiService.getJwtToken();
    return await apiService.getUserById(token!, widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                          text: 'Список проектов',
                          style: figmaTextStyles.header1Medium.copyWith(
                            color: FigmaColors.darkBlueMain,
                          ),
                        ),
                      ),
                    ),
                    SortIcon(
                      initialOrder: sortOrder,
                      onSortChanged: (order) {
                        setState(() {
                          sortOrder = order;
                          sortTasks(selectedIndex);
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (int index = 0; index < 3; index++)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                            sortTasks(index);
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: index == selectedIndex
                                    ? FigmaColors.darkBlueMain
                                    : Colors.transparent,
                                width: 2.0,
                              ),
                            ),
                          ),
                          child: Text(
                            index == 0
                                ? 'По дедлайну'
                                : index == 1
                                ? 'По преподавателю'
                                : 'По предмету',
                            style: figmaTextStyles.caption1Regular.copyWith(
                              color: index == selectedIndex
                                  ? FigmaColors.darkBlueMain
                                  : FigmaColors.exitColor,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          // Блок 2
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                itemCount: projectBlocks.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: ProjectBlockWidget(
                      subject: projectBlocks[index].subject,
                      endDate: projectBlocks[index].endDate,
                      teacher: projectBlocks[index].teacher,
                      userId: widget.userId,
                      description: projectBlocks[index].description,
                      taskId: projectBlocks[index].taskId,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FutureBuilder<User>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            User user = snapshot.data!;
            return user.role != 'STUDENT'
                ? FloatingActionButton(
              onPressed: () {
                AppRoutes.navigateToPageWithFadeTransition(
                    context,
                    TasksCreatePage(
                      userId: widget.userId,
                      subject: '',
                      date: '',
                      teacher: '',
                      description: '',
                      taskId: 0,
                    ));
              },
              child: Icon(Icons.create_outlined),
              backgroundColor: FigmaColors.contrastToMain,
            )
                : Container(); // Возвращаем пустой контейнер вместо null
          } else {
            return Container(); // Возвращаем пустой контейнер вместо null
          }
        },
      ),
    );
  }

  Future<void> fetchTasks() async {
    try {
      final token = await apiService.getJwtToken() ?? '';
      final User user = await apiService.getUserById(token, widget.userId);
      int groupId = user.groupId!;
      final tasks = await apiService.getTasksByGroupId(token, groupId);
      final taskBlockWidgets = await Future.wait(tasks.map((task) async {
        final teacher = await apiService.getUserById(token, task.teacherUserId);
        return ProjectBlockWidget(
          subject: task.name,
          endDate: task.endDate,
          teacher: "${teacher.name} ${teacher.surname} ${teacher.patronymic}",
          userId: widget.userId,
          description: task.description,
          taskId: task.id,
        );
      }).toList());

      setState(() {
        projectBlocks = taskBlockWidgets;
      });
    } catch (e) {
      print('Error fetching tasks: $e');
    }
  }

  void sortTasksByDeadline() {
    setState(() {
      projectBlocks.sort((a, b) {
        return sortOrder == SortOrder.ascending
            ? a.endDate.compareTo(b.endDate)
            : b.endDate.compareTo(a.endDate);
      });
    });
  }

  void sortTasksByTeacher() {
    setState(() {
      projectBlocks.sort((a, b) {
        return sortOrder == SortOrder.ascending
            ? a.teacher.compareTo(b.teacher)
            : b.teacher.compareTo(a.teacher);
      });
    });
  }

  void sortTasksBySubject() {
    setState(() {
      projectBlocks.sort((a, b) {
        return sortOrder == SortOrder.ascending
            ? a.subject.compareTo(b.subject)
            : b.subject.compareTo(a.subject);
      });
    });
  }

  void sortTasks(int index) {
    switch (index) {
      case 0:
        sortTasksByDeadline();
        break;
      case 1:
        sortTasksByTeacher();
        break;
      case 2:
        sortTasksBySubject();
        break;
      default:
        break;
    }
  }
}
