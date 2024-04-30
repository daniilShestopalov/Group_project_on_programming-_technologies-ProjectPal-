import 'package:project_pal/core/app_export.dart';

class TaskBlockWidget extends StatefulWidget {
  final String subject;
  final String date;
  final String teacher;
  final List<Task> tasks;
  final int userId;

  TaskBlockWidget({
    required this.subject,
    required this.date,
    required this.teacher,
    required this.tasks,
    required this.userId,
  });

  @override
  _TaskBlockWidgetState createState() => _TaskBlockWidgetState();
}

class _TaskBlockWidgetState extends State<TaskBlockWidget> {
  bool _isExpanded = false;
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();


  @override
  Widget build(BuildContext context) {
    String remainingDaysText;
    int days = int.parse(widget.date);

    if (days == 1) {
      remainingDaysText = ' день';
    } else if (days > 1 && days < 5) {
      remainingDaysText = ' дня';
    } else {
      remainingDaysText = ' дней';
    }

    return GestureDetector(
      onTap: () {
        AppRoutes.navigateToPageWithFadeTransition(context, ConcreteTaskPage(
            userId: widget.userId,
            subject: widget.subject,
            date: widget.date,
            teacher: widget.teacher,
            tasks: widget.tasks
        ));
      },
      child: Container(
        decoration: BoxDecoration(
          color: _calculateBlockColor(),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: Offset(0, 2),
              blurRadius: 6,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: widget.subject,
                            style: figmaTextStyles.header2Medium.copyWith(
                              color: FigmaColors.darkBlueMain,
                            ),
                          ),
                          CustomText(
                            text: widget.teacher,
                            style: figmaTextStyles.caption1Regular.copyWith(
                              color: FigmaColors.darkBlueMain,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Image.asset(ImageConstant.timeIcon),
                        SizedBox(width: 4),
                        CustomText(
                          text: widget.date + '$remainingDaysText',
                          style: figmaTextStyles.header2Medium.copyWith(
                            color: FigmaColors.darkBlueMain,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 8,
                            decoration: BoxDecoration(
                              color: FigmaColors.darkBlueMain,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: _calculateCompletionPercentage(),
                            child: Container(
                              height: 8,
                              decoration: BoxDecoration(
                                color: FigmaColors.contrastToMain,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1),
                    ],
                  ),
                ),
              ),
              if (_isExpanded) ...[
                for (var task in widget.tasks)
                  CheckboxListTile(
                    value: task.isCompleted,
                    onChanged: (value) {
                    },
                    title: Text(
                      task.description,
                      style: TextStyle(
                        color: FigmaColors.darkBlueMain,
                      ),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: Colors.blue,
                  ),
                SizedBox(height: 1),
              ],
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: FigmaColors.darkBlueMain,
                        size: 50,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Color _calculateBlockColor() {
    double completionPercentage = _calculateCompletionPercentage();
    if (completionPercentage == 1.0) {
      return Color(0xFF49CC77);
    } else {
      return Colors.red.withOpacity(0.5 + 0.5 * (1 - completionPercentage));
    }
  }

  double _calculateCompletionPercentage() {
    int completedTasks = widget.tasks.where((task) => task.isCompleted).length;
    return completedTasks / widget.tasks.length;
  }
}