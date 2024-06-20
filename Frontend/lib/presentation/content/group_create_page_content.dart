import 'package:project_pal/core/app_export.dart';

class GroupCreatePageContent extends StatefulWidget {

  final int userId;

  const GroupCreatePageContent({
    required this.userId,
  });

  @override
  _GroupCreatePageContentState createState() => _GroupCreatePageContentState();
}

class _GroupCreatePageContentState extends State<GroupCreatePageContent> {
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Container(
      padding: EdgeInsets.only(top: 36),
      child: GroupBlockOpenCreateWidget(userId: widget.userId, groupId: 0,),
    ),
  );
}
