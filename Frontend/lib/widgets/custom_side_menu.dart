import 'package:project_pal/core/app_export.dart';
import 'package:flutter/material.dart';

class CustomSideMenu extends StatefulWidget {
  final FigmaTextStyles figmaTextStyles;
  final int userId;

  const CustomSideMenu({
    Key? key,
    required this.figmaTextStyles,
    required this.userId,
  }) : super(key: key);

  @override
  _CustomSideMenuState createState() => _CustomSideMenuState();
}

class _CustomSideMenuState extends State<CustomSideMenu> {
  late ApiService apiService;
  dynamic user;
  String userRole = '';
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      final token = await apiService.getJwtToken();
      if (token != null) {
        user = await apiService.getUserById(token, widget.userId);
        if (user != null) {
          print(user.role);
          switch (user.role) {
            case 'STUDENT':
              userRole = 'Студент';
              break;
            case 'TEACHER':
              userRole = 'Преподаватель';
              break;
            case 'ADMIN':
              userRole = 'Администратор';
              break;
            default:
              userRole = 'Неизвестно';
          }
        } else {
          errorMessage = 'Ошибка: Пользователь не загружен';
        }
      } else {
        errorMessage = 'Ошибка: Токен не получен';
      }
    } catch (e) {
      errorMessage = 'Ошибка при инициализации данных: $e';
    }
    setState(() {}); // Обновить состояние после загрузки данных
  }

  @override
  Widget build(BuildContext context) {
    if (errorMessage.isNotEmpty) {
      return Center(child: Text(errorMessage));
    }

    if (user == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Drawer(
      child: Container(
        color: FigmaColors.whiteBackground,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            CustomText(
              text: '${user.surname ?? ''} ${user.name ?? ''} ${user.patronymic ?? ''}',
              style: widget.figmaTextStyles.mediumText.copyWith(
                color: FigmaColors.darkBlueMain,
              ),
            ),
            SizedBox(height: 5),
            CustomText(
              text: userRole,
              style: widget.figmaTextStyles.regularText.copyWith(
                color: FigmaColors.darkBlueMain,
              ),
            ),
            SizedBox(height: 30),
            _buildMenuItem(
              icon: Icons.person,
              text: 'Профиль',
              onTap: () {
                AppRoutes.navigateToPageWithFadeTransition(
                    context, ProfilePage(userId: widget.userId));
              },
            ),
            _buildMenuItem(
              icon: Icons.group,
              text: 'Группы',
              onTap: () {
                AppRoutes.navigateToPageWithFadeTransition(
                    context, GroupsPage(userId: widget.userId));
              },
            ),
            _buildMenuItem(
              icon: Icons.groups,
              text: 'Учащиеся',
              onTap: () {
                AppRoutes.navigateToPageWithFadeTransition(
                    context, StudentsPage(userId: widget.userId));
              },
            ),
            _buildMenuItem(
              icon: Icons.account_balance,
              text: 'Преподаватели',
              onTap: () {
                AppRoutes.navigateToPageWithFadeTransition(
                    context, ProfessorPage(userId: widget.userId));
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
              style: widget.figmaTextStyles.regularText.copyWith(
                color: FigmaColors.darkBlueMain,
              ),
            ),
            SizedBox(height: 10),
            _buildMenuItem(
              icon: Icons.home,
              text: 'Главная',
              onTap: () {
                AppRoutes.navigateToPageWithFadeTransition(
                    context, MainPage(userId: widget.userId));
              },
            ),
            _buildMenuItem(
              icon: Icons.calendar_today,
              text: 'Календарь',
              onTap: () {
                AppRoutes.navigateToPageWithFadeTransition(
                    context, CalendarPage(userId: widget.userId));
              },
            ),
            _buildMenuItem(
              icon: Icons.assignment,
              text: 'Задания',
              onTap: () {
                AppRoutes.navigateToPageWithFadeTransition(
                    context, TasksPage(userId: widget.userId));
              },
            ),
            _buildMenuItem(
              icon: Icons.group_work,
              text: 'Проекты',
              onTap: () {
                AppRoutes.navigateToPageWithFadeTransition(
                    context, ProjectPage(userId: widget.userId));
              },
            ),
            if (user.role == 'ADMIN')
              _buildMenuItem(
                icon: Icons.fmd_bad_sharp,
                text: 'Жалобы',
                onTap: () {
                  AppRoutes.navigateToPageWithFadeTransition(
                      context, ComplaintPage(userId: widget.userId));
                },
              ),
            if (user.role == 'ADMIN')
              _buildMenuItem(
                icon: Icons.person_add,
                text: 'Создать пользователя',
                onTap: () {
                  AppRoutes.navigateToPageWithFadeTransition(
                      context, UserCreatePage(userId: widget.userId));
                },
              ),// Remove the comma here
            SizedBox(height: 20),
            Divider(
              color: FigmaColors.darkBlueMain.withOpacity(0.2),
              thickness: 1,
            ),
            SizedBox(height: 10),
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
    required VoidCallback onTap,
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
              style: widget.figmaTextStyles.regularText.copyWith(
                color: FigmaColors.darkBlueMain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
