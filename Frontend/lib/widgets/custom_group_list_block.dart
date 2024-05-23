import 'package:flutter/material.dart';
import 'package:project_pal/core/app_export.dart';

class CustomGroupListBlock extends StatelessWidget {
  final int userId;
  final Group group;

  const CustomGroupListBlock({
    Key? key,
    required this.userId,
    required this.group,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppRoutes.navigateToPageWithFadeTransition(context, GroupsViewPage(userId: userId, groupNumber: group.groupNumber.toString()));
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(
                Icons.group,
                color: FigmaColors.darkBlueMain,
              ),
            ),
            SizedBox(width: 8),
            Text(
              group.courseNumber.toString(), // Отображаем номер курса
              style: TextStyle(
                fontSize: 16,
                color: FigmaColors.darkBlueMain,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Группа ${group.groupNumber}',
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
