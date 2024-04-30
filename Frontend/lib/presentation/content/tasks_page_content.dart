import 'package:project_pal/core/app_export.dart';

class TasksPageContent extends StatefulWidget {

  final int userId;

  const TasksPageContent({Key? key, required this.userId}) : super(key: key);

  @override
  _TasksPageContentState createState() => _TasksPageContentState();
}

class _TasksPageContentState extends State<TasksPageContent> {
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();

  SortOrder sortOrder = SortOrder.ascending;
  int selectedIndex = 0;

  List<TaskBlockWidget> taskBlocks = DataUtils.getTasksData().map((taskData) {

    Duration daysUntilEndDate = taskData['endDate'].difference(DateTime.now());
    String remainingDays = '${daysUntilEndDate.inDays}';

    return TaskBlockWidget(
      subject: taskData['name'],
      date: '$remainingDays',
      teacher: DataUtils.getTeacherNameById(taskData['teacherId']),
      tasks: [
        Task(description: taskData['description'], isCompleted: false),
      ],
      userId: 0,
    );
  }).toList();

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
                    date: taskBlocks[index].date,
                    teacher: taskBlocks[index].teacher,
                    tasks: taskBlocks[index].tasks,
                    userId: widget.userId,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void sortTasksByDeadline() {
    setState(() {
      taskBlocks.sort((a, b) {
        int remainingDaysA = int.parse(a.date);
        int remainingDaysB = int.parse(b.date);
        return sortOrder == SortOrder.ascending ? remainingDaysA.compareTo(remainingDaysB) : remainingDaysB.compareTo(remainingDaysA);
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
