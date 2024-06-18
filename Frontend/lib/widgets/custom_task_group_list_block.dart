import 'package:project_pal/core/app_export.dart';

class CustomTaskGroupListBlock extends StatefulWidget {
  final Group group;
  final String subject;
  final DateTime endDate;
  final DateTime startDate;
  final String teacher;
  final int userId;
  final String description;
  final String fileLink;
  final int taskId;
  final String endDateString;

  const CustomTaskGroupListBlock({
    Key? key,
    required this.userId,
    required this.group,
    required this.subject,
    required this.endDate,
    required this.startDate,
    required this.teacher,
    required this.description,
    required this.fileLink,
    required this.taskId,
    required this.endDateString,
  }) : super(key: key);

  @override
  State<CustomTaskGroupListBlock> createState() => _CustomTaskGroupListBlockState();
}

class _CustomTaskGroupListBlockState extends State<CustomTaskGroupListBlock> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppRoutes.navigateToPageWithFadeTransition(
            context,
            TaskGroupViewPage(
              userId: widget.userId,
              group: widget.group,
              subject: widget.subject,
              endDate: widget.endDate,
              startDate: widget.startDate,
              teacher: widget.teacher,
              description: widget.description,
              fileLink: widget.fileLink,
              taskId: widget.taskId,
              endDateString: widget.endDateString,
            ));
      },
      child: Container(
        width: 312,
        height: 50,
        decoration: BoxDecoration(
          color: Color(0xFFC6D8DE),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(
                Icons.group,
                color: FigmaColors.darkBlueMain,
              ),
            ),
            SizedBox(width: 8),
            Text(
              widget.group.countOfPeople.toString(), // Отображаем номер курса
              style: TextStyle(
                fontSize: 16,
                color: FigmaColors.darkBlueMain,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Курс: ${widget.group.courseNumber}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: FigmaColors.darkBlueMain,
                    ),
                  ),
                  Text(
                    'Группа: ${widget.group.groupNumber}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: FigmaColors.darkBlueMain,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
