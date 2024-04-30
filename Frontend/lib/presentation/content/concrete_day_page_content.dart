import 'package:intl/intl.dart';
import 'package:project_pal/core/app_export.dart';

class ConcreteDayPageContent extends StatefulWidget {

  final int userId;
  final List<Map<String, dynamic>> tasks;
  final DateTime selectedDate;

  const ConcreteDayPageContent({Key? key, required this.userId, required this.tasks, required this.selectedDate, }) : super(key: key);

  @override
  _ConcreteDayPageContentState createState() => _ConcreteDayPageContentState();
}

class _ConcreteDayPageContentState extends State<ConcreteDayPageContent> {
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();

  SortOrder sortOrder = SortOrder.ascending;
  int selectedIndex = 0;

  List<TaskBlockWidget> taskBlocks = [];

  @override
  void initState() {
    super.initState();

    taskBlocks = widget.tasks.map((taskData) {
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
                        text: 'Задания на ${DateFormat('dd MMMM', 'ru').format(widget.selectedDate)}',
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
                if (taskBlocks.isNotEmpty && index < taskBlocks.length) {
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
                } else {
                  return SizedBox(); // Возвращаем пустой виджет, если список пуст или индекс недействителен.
                }
              },
            )
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