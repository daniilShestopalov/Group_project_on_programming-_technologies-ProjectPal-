import 'package:intl/intl.dart';
import 'package:project_pal/core/app_export.dart';

class ConcreteDayPageContent extends StatefulWidget {
  final int userId;
  final DateTime selectedDate;
  final List<int> taskIds;

  const ConcreteDayPageContent({
    Key? key,
    required this.userId,
    required this.selectedDate,
    required this.taskIds,
  }) : super(key: key);

  @override
  _ConcreteDayPageContentState createState() => _ConcreteDayPageContentState();
}

class _ConcreteDayPageContentState extends State<ConcreteDayPageContent> {
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();
  final ApiService apiService = ApiService();
  SortOrder sortOrder = SortOrder.ascending;
  int selectedIndex = 0;
  List<TaskBlockWidget> taskBlocks = [];

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              itemCount: taskBlocks.length,
              itemBuilder: (context, index) {
                if (taskBlocks.isNotEmpty && index < taskBlocks.length) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: taskBlocks[index],
                  );
                } else {
                  return SizedBox(); // Возвращаем пустой виджет, если список пуст или индекс недействителен.
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  // Функция для получения задач по их идентификаторам
  Future<void> fetchTasks() async {
    try {
      final token = await apiService.getJwtToken() ?? '';
      final tasks = await Future.wait(widget.taskIds.map((taskId) async {
        return apiService.getTaskById(token, taskId); // Получаем задачу по идентификатору
      }));
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
  // Функции сортировки задач
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
