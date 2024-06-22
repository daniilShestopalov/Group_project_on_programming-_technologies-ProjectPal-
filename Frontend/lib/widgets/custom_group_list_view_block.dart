import 'package:project_pal/core/app_export.dart';

class CustomGroupListViewBlock extends StatelessWidget {
  final int userId;
  final User user;

  const CustomGroupListViewBlock({
    Key? key,
    required this.userId,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (userId == user.id) {
          AppRoutes.navigateToPageWithFadeTransition(context, ProfilePage(userId: userId));
        } else {
          AppRoutes.navigateToPageWithFadeTransition(context, ProfileViewPage(userId: userId, userViewId: user.id));
        }
        
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
                '${user.surname} ${user.name} ${user.patronymic}',
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
