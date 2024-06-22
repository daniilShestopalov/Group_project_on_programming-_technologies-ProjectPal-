import 'package:project_pal/core/app_export.dart';

class ProjectUpdatePageContent extends StatefulWidget {

  final int userId;
  final String subject;
  final DateTime endDate;
  final DateTime startDate;
  final String teacher;
  final String description;
  final int taskId;
  final String fileLink;

  const ProjectUpdatePageContent({
    required this.userId,
    required this.subject,
    required this.endDate,
    required this.startDate,
    required this.teacher,
    required this.description,
    required this.taskId,
    required this.fileLink,
  });

  @override
  _ProjectUpdatePageContentState createState() => _ProjectUpdatePageContentState();
}

class _ProjectUpdatePageContentState extends State<ProjectUpdatePageContent> {
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Container(
      padding: EdgeInsets.only(top: 36),
      child: ProjectBlockOpenUpdateWidget(
        subject: widget.subject,
        teacher: widget.teacher,
        userId: widget.userId,
        instruction: widget.description,
        projectId: widget.taskId,
        endDate: widget.endDate,
        startDate: widget.startDate,
        fileLink: widget.fileLink,
      ),
    ),
  );
}
