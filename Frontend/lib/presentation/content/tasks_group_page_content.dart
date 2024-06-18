import 'package:project_pal/core/app_export.dart';

class TasksGroupPageContent extends StatefulWidget {
  final String subject;
  final DateTime endDate;
  final DateTime startDate;
  final String teacher;
  final int userId;
  final String description;
  final String fileLink;
  final int taskId;
  final String endDateString;

  const TasksGroupPageContent(
      {Key? key,
      required this.userId,
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
  _TasksGroupPageContentState createState() => _TasksGroupPageContentState();
}

class _TasksGroupPageContentState extends State<TasksGroupPageContent> {
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();
  final ApiService apiService = ApiService();

  SortOrder sortOrder = SortOrder.ascending;
  int selectedIndex = 0;

  List<Group> groupBlocks = [];

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    try {
      final token = await apiService.getJwtToken();

      if (token == null) {
        throw Exception('Token is null');
      }

      final groups = await apiService.fetchGroups(token);

      for (var group in groups) {
        final countOfPeople = await apiService.getUserCountByGroup(
            group.id, token); // Передача id группы
        group.countOfPeople = countOfPeople;
      }

      setState(() {
        groupBlocks = groups;
      });
    } catch (error) {
      print('Error during loading groups: $error');
    }
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
                        text: 'Группы',
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
                        sortGroups(selectedIndex);
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
                          sortGroups(index);
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
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
                              ? 'По номеру'
                              : index == 1
                                  ? 'По количеству'
                                  : 'По курсу',
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
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: ListView.builder(
              itemCount: groupBlocks.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: CustomTaskGroupListBlock(
                    userId: widget.userId,
                    group: groupBlocks[index],
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

  void sortGroupsByNumberOfGroup() {
    setState(() {
      groupBlocks.sort((a, b) {
        return sortOrder == SortOrder.ascending
            ? a.groupNumber.compareTo(b.groupNumber)
            : b.groupNumber.compareTo(a.groupNumber);
      });
    });
  }

  void sortGroupsByNumberOfPeople() {
    setState(() {
      groupBlocks.sort((a, b) {
        return sortOrder == SortOrder.ascending
            ? a.countOfPeople.compareTo(b.countOfPeople)
            : b.countOfPeople.compareTo(a.countOfPeople);
      });
    });
  }

  void sortGroupsByNumberOfCourse() {
    setState(() {
      groupBlocks.sort((a, b) {
        return sortOrder == SortOrder.ascending
            ? a.courseNumber.compareTo(b.courseNumber)
            : b.courseNumber.compareTo(a.courseNumber);
      });
    });
  }

  void sortGroups(int index) {
    switch (index) {
      case 0:
        sortGroupsByNumberOfGroup();
        break;
      case 1:
        sortGroupsByNumberOfPeople();
        break;
      case 2:
        sortGroupsByNumberOfCourse();
        break;
      default:
        break;
    }
  }
}
