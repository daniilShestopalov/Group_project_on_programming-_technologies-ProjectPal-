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

  @override
  Widget build(BuildContext context) {
    List<DateTime> daysInMonth = _getDaysInMonth(currentDate);

    Map<DateTime, int> tasksPerDay = {};

// Проходим по всем задачам в списке tasksData
    for (var task in MockData.tasksData) {
      DateTime endDate = task['endDate']; // Берем endDate как ключ для tasksPerDay

      // Если в tasksPerDay уже есть ключ с такой датой, увеличиваем его значение на 1
      // Иначе создаем новую запись с ключом endDate и значением 1
      tasksPerDay.update(endDate, (value) => value + 1, ifAbsent: () => 1);
    }


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
                      });
                    },
                    onTapArrowRight: () {
                      setState(() {
                        currentDate = DateTime(currentDate.year, currentDate.month + 1);
                        daysInMonth = _getDaysInMonth(currentDate);
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
              child: CustomCalendarGrid(daysInMonth: daysInMonth, tasksPerDay: tasksPerDay, userId: widget.userId), // Передаем моканные данные в CustomCalendarGrid
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
