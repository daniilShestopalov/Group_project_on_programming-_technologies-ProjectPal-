import 'package:project_pal/core/app_export.dart';

class GroupUpdatePageContent extends StatefulWidget {

  final int userId;
  final int groupId;

  const GroupUpdatePageContent({
    required this.userId, required this.groupId,
  });

  @override
  _GroupUpdatePageContentState createState() => _GroupUpdatePageContentState();
}

class _GroupUpdatePageContentState extends State<GroupUpdatePageContent> {
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Container(
      padding: EdgeInsets.only(top: 36),
      child: GroupBlockOpenUpdateWidget(userId: widget.userId, groupId: widget.groupId,),
    ),
  );
}
