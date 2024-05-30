import 'package:project_pal/core/app_export.dart';

class ConcreteTaskPageContent extends StatefulWidget {

  final int userId;
  final String subject;
  final String date;
  final String teacher;

  const ConcreteTaskPageContent({
    required this.userId,
    required this.subject,
    required this.date,
    required this.teacher,
  });

  @override
  _ConcreteTaskPageContentState createState() => _ConcreteTaskPageContentState();
}

class _ConcreteTaskPageContentState extends State<ConcreteTaskPageContent> {
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Container(
      padding: EdgeInsets.only(bottom: 16),
      child: TaskBlockOpenWidget(
        subject: widget.subject,
        date: widget.date,
        teacher: widget.teacher,
        userId: widget.userId,
        instruction: '',
      ),
    ),
  );
}
