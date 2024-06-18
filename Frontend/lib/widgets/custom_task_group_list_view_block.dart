import 'package:flutter/material.dart';
import 'package:project_pal/core/app_export.dart';

class CustomTaskGroupListViewBlock extends StatefulWidget {
  final int userId;
  final User user;
  final Group group;
  final String subject;
  final DateTime endDate;
  final DateTime startDate;
  final String teacher;
  final String description;
  final String fileLink;
  final int taskId;
  final String endDateString;

  const CustomTaskGroupListViewBlock({
    Key? key,
    required this.userId,
    required this.user,
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
  _CustomTaskGroupListViewBlockState createState() =>
      _CustomTaskGroupListViewBlockState();
}

class _CustomTaskGroupListViewBlockState
    extends State<CustomTaskGroupListViewBlock> {
  late ApiService apiService;
  late int answerId;
  late DateTime submissionDate;
  late String teacherComment;
  late int teacherGrade;
  late String answerLink;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    _loadTaskAnswer();
  }

  Future<void> _loadTaskAnswer() async {
    try {
      String token = await apiService.getJwtToken() ?? '';
      final List<Map<String, dynamic>> data =
          await apiService.getTaskAnswerByTaskId(token, widget.userId);
      if (data.isNotEmpty) {
        setState(() {
          answerId = data[0]['id'];
          submissionDate = data[0]['submissionDate'] != null
              ? DateTime.parse(data[0]['submissionDate'])
              : DateTime.now();
          teacherComment = data[0]['teacherCommentary'] ?? '';
          teacherGrade = data[0]['grade'];
          answerLink = data[0]['fileLink'] ?? '';
        });
      } else {
        print('No task answer found');
      }
    } catch (e) {
      print('Failed to load task answer: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppRoutes.navigateToPageWithFadeTransition(
            context,
            ConcreteTaskPage(
              userId: widget.userId,
              subject: widget.subject,
              date: widget.endDateString,
              teacher: widget.teacher,
              description: widget.description,
              taskId: widget.taskId,
              startDate: widget.startDate,
              fileLink: widget.fileLink,
              studentID: widget.user.id,
            ));
      },
      child: Container(
        width: 312,
        height: 38,
        decoration: BoxDecoration(
          color: Color(0xFFC6D8DE),
          borderRadius: BorderRadius.circular(8),
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
            Expanded(
              child: Text(
                '${widget.user.surname} ${widget.user.name} ${widget.user.patronymic}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: FigmaColors.darkBlueMain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
