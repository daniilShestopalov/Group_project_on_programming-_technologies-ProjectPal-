import 'package:intl/intl.dart';
import 'package:project_pal/core/app_export.dart';

class CalendarPageContent extends StatefulWidget {
  final int userId;

  const CalendarPageContent({Key? key, required this.userId}) : super(key: key);

  @override
  _CalendarPageContentState createState() => _CalendarPageContentState();
}

class _CalendarPageContentState extends State<CalendarPageContent> {
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();
  DateTime currentDate = DateTime.now();
  final ApiService apiService = ApiService();
  late String token;
  List<Tasks> tasks = [];
  Map<DateTime, List<int>> taskIdsPerDay = {}; // Изменено на Map<DateTime, List<int>>
  late int groupId;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    token = await apiService.getJwtToken() ?? '';

    await _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    try {
      final user = await apiService.getUserById(token, widget.userId);
      groupId = user.groupId ?? 0;
      tasks = await apiService.getTasksByMonthAndGroup(
        groupId,
        currentDate.year,
        currentDate.month,
        token,
      );

      taskIdsPerDay.clear();
      for (var task in tasks) {
        DateTime endDate = DateTime(task.endDate.year, task.endDate.month, task.endDate.day);
        taskIdsPerDay.update(endDate, (value) => [...value, task.id], ifAbsent: () => [task.id]); // Обновлено для добавления идентификатора задачи в список
      }
      print('Таски: $taskIdsPerDay');

      setState(() {});
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> daysInMonth = _getDaysInMonth(currentDate);

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
                        text: 'Календарь',
                        style: figmaTextStyles.header1Medium.copyWith(
                          color: FigmaColors.darkBlueMain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 8),
                  CustomButton(
                    text: DateFormat('MMMM', 'ru').format(currentDate),
                    onPressed: () {},
                    figmaTextStyles: figmaTextStyles,
                    showArrows: true,
                    onTapArrowLeft: () {
                      setState(() {
                        currentDate = DateTime(currentDate.year, currentDate.month - 1);
                        daysInMonth = _getDaysInMonth(currentDate);
                        _fetchTasks();
                      });
                    },
                    onTapArrowRight: () {
                      setState(() {
                        currentDate = DateTime(currentDate.year, currentDate.month + 1);
                        daysInMonth = _getDaysInMonth(currentDate);
                        _fetchTasks();
                      });
                    },
                  ),
                  SizedBox(width: 8),
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: CustomCalendarGrid(
                daysInMonth: daysInMonth,
                userId: widget.userId,
                taskIdsPerDay: taskIdsPerDay,
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<DateTime> _getDaysInMonth(DateTime currentDate) {
    final int daysInMonth = DateTime(currentDate.year, currentDate.month + 1, 0).day;
    final List<DateTime> days = [];
    for (int i = 1; i <= daysInMonth; i++) {
      days.add(DateTime(currentDate.year, currentDate.month, i));
    }
    return days;
  }
}
