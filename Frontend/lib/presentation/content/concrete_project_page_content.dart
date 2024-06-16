import 'package:project_pal/core/app_export.dart';

class ConcreteProjectPageContent extends StatefulWidget {

  final int userId;
  final String subject;
  final String date;
  final String teacher;
  final String description;
  final int taskId;

  const ConcreteProjectPageContent({
    required this.userId,
    required this.subject,
    required this.date,
    required this.teacher,
    required this.description,
    required this.taskId,
  });

  @override
  _ConcreteProjectPageContentState createState() => _ConcreteProjectPageContentState();
}

class _ConcreteProjectPageContentState extends State<ConcreteProjectPageContent> {
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Container(
      padding: EdgeInsets.only(top: 26),
      child: ProjectBlockOpenWidget(
        subject: widget.subject,
        date: widget.date,
        teacher: widget.teacher,
        userId: widget.userId,
        instruction: widget.description,
        taskId: widget.taskId,
      ),
    ),
  );
}
