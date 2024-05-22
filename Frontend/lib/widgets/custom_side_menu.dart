import 'package:project_pal/core/app_export.dart';

class CustomSideMenu extends StatelessWidget {
  final FigmaTextStyles figmaTextStyles;

  final int userId;

  const CustomSideMenu({
    Key? key,
    required this.figmaTextStyles,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: FigmaColors.whiteBackground,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            CustomText(
              text: DataUtils.getUserFullNameById(userId),
              style: figmaTextStyles.mediumText.copyWith(
                color: FigmaColors.darkBlueMain,
              ),
            ),
            SizedBox(height: 5),
            CustomText(
              text: DataUtils.getRoleName(DataUtils.getUserRoleById(userId)),
              style: figmaTextStyles.regularText.copyWith(
                color: FigmaColors.darkBlueMain,
              ),
            ),
            SizedBox(height: 30),
            _buildMenuItem(
              icon: Icons.person,
              text: 'Профиль',
              onTap: () {
                AppRoutes.navigateToPageWithFadeTransition(context, ProfilePage(userId: userId));
              },
            ),
            _buildMenuItem(
              icon: Icons.group,
              text: 'Группы',
              onTap: () {
                AppRoutes.navigateToPageWithFadeTransition(context, GroupsPage(userId: userId));
              },
            ),
            _buildMenuItem(
              icon: Icons.account_balance,
              text: 'Преподаватели',
              onTap: () {
                AppRoutes.navigateToPageWithFadeTransition(context, ProfessorPage(userId: userId,));
              },
            ),
            SizedBox(height: 20),
            Divider(
              color: FigmaColors.darkBlueMain.withOpacity(0.2),
              thickness: 1,
            ),
            SizedBox(height: 10),
            CustomText(
              text: 'Основные функции',
              style: figmaTextStyles.regularText.copyWith(
                color: FigmaColors.darkBlueMain,
              ),
            ),
            SizedBox(height: 10),
            _buildMenuItem(
              icon: Icons.home,
              text: 'Главная',
              onTap: () {
                AppRoutes.navigateToPageWithFadeTransition(context, MainPage(userId: userId));
              },
            ),
            _buildMenuItem(
              icon: Icons.calendar_today,
              text: 'Календарь',
              onTap: () {
                AppRoutes.navigateToPageWithFadeTransition(context, CalendarPage(userId: userId));
              },
            ),
            _buildMenuItem(
              icon: Icons.assignment,
              text: 'Задания',
              onTap: () {
                AppRoutes.navigateToPageWithFadeTransition(context, TasksPage(userId: userId));
              },
            ),
            _buildMenuItem(
              icon: Icons.group_work,
              text: 'Проекты',
              onTap: () {
                AppRoutes.navigateToPageWithFadeTransition(context, ProjectPage(userId: userId));
              },
            ),
            SizedBox(height: 20),
            Divider(
              color: FigmaColors.darkBlueMain.withOpacity(0.2),
              thickness: 1,
            ),
            SizedBox(height: 10),
            _buildMenuItem(
              icon: Icons.settings,
              text: 'Настройки',
              onTap: () {
                AppRoutes.navigateToPageWithFadeTransition(context, SettingsPage(userId: userId,));
              },
            ),
            _buildMenuItem(
              icon: Icons.exit_to_app,
              text: 'Выйти из профиля',
              iconColor: FigmaColors.red,
              onTap: () {
                AppRoutes.navigateToPageWithFadeTransition(context, AuthPage());
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    Color? iconColor,
    required VoidCallback onTap, // Обновленный параметр onTap
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor ?? FigmaColors.darkBlueMain,
            ),
            SizedBox(width: 24),
            CustomText(
              text: text,
              style: figmaTextStyles.regularText.copyWith(
                color: FigmaColors.darkBlueMain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
