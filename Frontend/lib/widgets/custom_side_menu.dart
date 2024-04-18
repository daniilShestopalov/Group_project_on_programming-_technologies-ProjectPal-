import 'package:project_pal/core/app_export.dart';

class CustomSideMenu extends StatelessWidget {
  final FigmaTextStyles figmaTextStyles;

  const CustomSideMenu({
    Key? key,
    required this.figmaTextStyles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            CustomText(
              text: 'Третьяков Данила Сергеевич',
              style: figmaTextStyles.mediumText.copyWith(
                color: FigmaColors.darkBlueMain,
              ),
            ),
            SizedBox(height: 5),
            CustomText(
              text: 'Студент',
              style: figmaTextStyles.regularText.copyWith(
                color: FigmaColors.darkBlueMain,
              ),
            ),
            SizedBox(height: 30),
            _buildMenuItem(
              icon: Icons.person,
              text: 'Профиль',
              onTap: () {
                // Действия при выборе пункта меню "Профиль"
              },
            ),
            _buildMenuItem(
              icon: Icons.group,
              text: 'Группы',
              onTap: () {
                // Действия при выборе пункта меню "Группы"
              },
            ),
            _buildMenuItem(
              icon: Icons.people,
              text: 'Преподаватели',
              onTap: () {
                // Действия при выборе пункта меню "Преподаватели"
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
                // Действия при выборе пункта меню "Главная"
              },
            ),
            _buildMenuItem(
              icon: Icons.calendar_today,
              text: 'Календарь',
              onTap: () {
                // Действия при выборе пункта меню "Календарь"
              },
            ),
            _buildMenuItem(
              icon: Icons.assignment,
              text: 'Задания',
              onTap: () {
                // Действия при выборе пункта меню "Задания"
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
                // Действия при выборе пункта меню "Настройки"
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
