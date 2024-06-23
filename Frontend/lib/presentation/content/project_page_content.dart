import 'package:project_pal/core/app_export.dart';

class ProjectPageContent extends StatefulWidget {
  final int userId;

  const ProjectPageContent({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  _ProjectPageContentState createState() => _ProjectPageContentState();
}

class _ProjectPageContentState extends State<ProjectPageContent> {
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();
  final ApiService apiService = ApiService();
  SortOrder sortOrder = SortOrder.ascending;
  User? user;
  int selectedIndex = 0;
  List<ProjectBlockWidget> taskBlocks = [];
  late Future<void> initializationFuture;

  @override
  void initState() {
    super.initState();
    initializationFuture = _initializeData();
  }

  Future<void> _initializeData() async {
    final token = await apiService.getJwtToken();
    user = await apiService.getUserById(token!, widget.userId);
    await fetchTasks(token);
    setState(() {}); // Перестроить виджет после получения данных
  }

  Future<void> fetchTasks(String token) async {
    try {
      final User user = await apiService.getUserById(token, widget.userId);
      List<Project> projects;
      if (user.role == 'STUDENT') {
        projects = await apiService.getProjectsByStudentId(token, user.id);
      } else {
        projects = await apiService.getProjectsByTeacherId(token, user.id);
        print(projects);
      }
      final taskBlockWidgets = await Future.wait(projects.map((project) async {
        final teacher = await apiService.getUserById(token, project.teacherUserId);
        print(project.endDate);
        print('ДЕДЛАЙН');
        return ProjectBlockWidget(
          subject: project.name,
          endDate: project.endDate,
          teacher: "${teacher.name} ${teacher.surname} ${teacher.patronymic}",
          userId: widget.userId,
          description: project.description ?? '',
          projectId: project.id,
          startDate: project.startDate,
          fileLink: project.fileLink ?? '',
          role: user.role,
        );
      }).toList());

      setState(() {
        taskBlocks = taskBlockWidgets;
      });
    } catch (e) {
      print('Error fetching tasks: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else {
          return Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Блок 1
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                                  style:
                                  figmaTextStyles.caption1Regular.copyWith(
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
                      itemCount: taskBlocks.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: ProjectBlockWidget(
                            role: user!.role,
                            subject: taskBlocks[index].subject,
                            endDate: taskBlocks[index].endDate,
                            teacher: taskBlocks[index].teacher,
                            userId: widget.userId,
                            description: taskBlocks[index].description,
                            projectId: taskBlocks[index].projectId,
                            startDate: taskBlocks[index].startDate,
                            fileLink: taskBlocks[index].fileLink,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButton: user?.role != 'STUDENT'
                ? FloatingActionButton(
              onPressed: () {
                AppRoutes.navigateToPageWithFadeTransition(
                    context,
                    ProjectCreatePage(
                      userId: widget.userId,
                      subject: '',
                      teacher: '',
                      description: '',
                      taskId: 0,
                      endDate: DateTime.now(),
                      startDate: DateTime.now(),
                      fileLink: '',
                    ));
              },
              child: Icon(Icons.create_outlined),
              backgroundColor: FigmaColors.contrastToMain,
            )
                : null,
          );
        }
      },
    );
  }

  void sortTasksByDeadline() {
    setState(() {
      taskBlocks.sort((a, b) {
        return sortOrder == SortOrder.ascending
            ? a.endDate.compareTo(b.endDate)
            : b.endDate.compareTo(a.endDate);
      });
    });
  }

  void sortTasksByTeacher() {
    setState(() {
      taskBlocks.sort((a, b) {
        return sortOrder == SortOrder.ascending
            ? a.teacher.compareTo(b.teacher)
            : b.teacher.compareTo(a.teacher);
      });
    });
  }

  void sortTasksBySubject() {
    setState(() {
      taskBlocks.sort((a, b) {
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