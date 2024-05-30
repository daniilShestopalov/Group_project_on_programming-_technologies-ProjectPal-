import 'package:project_pal/core/app_export.dart';

class TasksPageContent extends StatefulWidget {
  final int userId;

  const TasksPageContent({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  _TasksPageContentState createState() => _TasksPageContentState();
}

class _TasksPageContentState extends State<TasksPageContent> {
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();
  final ApiService apiService = ApiService();
  SortOrder sortOrder = SortOrder.ascending;
  late User user;
  int selectedIndex = 0;
  List<TaskBlockWidget> taskBlocks = [];

  @override
  void initState() {
    _initializeData();
    super.initState();
    fetchTasks();

  }

  Future<void> _initializeData() async {
    final token = await apiService.getJwtToken();
    user = await apiService.getUserById(token!, widget.userId);
    setState(() {}); // Перестроить виджет после получения данных
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
                          text: 'Список заданий',
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
                                color: index == selectedIndex ? FigmaColors.darkBlueMain : Colors.transparent,
                                width: 2.0,
                              ),
                            ),
                          ),
                          child: Text(
                            index == 0 ? 'По дедлайну' : index == 1 ? 'По преподавателю' : 'По предмету',
                            style: figmaTextStyles.caption1Regular.copyWith(
                              color: index == selectedIndex ? FigmaColors.darkBlueMain : FigmaColors.exitColor,
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
                    child: TaskBlockWidget(
                      subject: taskBlocks[index].subject,
                      endDate: taskBlocks[index].endDate,
                      teacher: taskBlocks[index].teacher,
                      userId: widget.userId,
                      description: taskBlocks[index].description,
                      taskId: taskBlocks[index].taskId,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: user.role != 'STUDENT'
          ? FloatingActionButton(
        onPressed: () {
          AppRoutes.navigateToPageWithFadeTransition(context, TasksCreatePage(userId: widget.userId, subject: '', date: '', teacher: '', description: '', taskId: 0,));
        },
        child: Icon(Icons.create_outlined),
        backgroundColor: FigmaColors.contrastToMain,
      )
          : null,
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
        return TaskBlockWidget(
          subject: task.name,
          endDate: task.endDate,
          teacher: "${teacher.name} ${teacher.surname} ${teacher.patronymic}",
          userId: widget.userId,
          description: task.description,
          taskId: task.id,
        );
      }).toList());

      setState(() {
        taskBlocks = taskBlockWidgets;
      });
    } catch (e) {
      print('Error fetching tasks: $e');
    }
  }

  void sortTasksByDeadline() {
    setState(() {
      taskBlocks.sort((a, b) {
        return sortOrder == SortOrder.ascending ? a.endDate.compareTo(b.endDate) : b.endDate.compareTo(a.endDate);
      });
    });
  }

  void sortTasksByTeacher() {
    setState(() {
      taskBlocks.sort((a, b) {
        return sortOrder == SortOrder.ascending ? a.teacher.compareTo(b.teacher) : b.teacher.compareTo(a.teacher);
      });
    });
  }

  void sortTasksBySubject() {
    setState(() {
      taskBlocks.sort((a, b) {
        return sortOrder == SortOrder.ascending ? a.subject.compareTo(b.subject) : b.subject.compareTo(a.subject);
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
