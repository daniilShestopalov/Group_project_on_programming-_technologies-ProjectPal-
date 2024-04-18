import 'package:project_pal/core/app_export.dart';

class CustomBottomBar extends StatelessWidget {
  final String currentPage;

  const CustomBottomBar({Key? key, required this.currentPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0, -2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: _buildBottomBarItem(
              icon: Icons.calendar_today,
              text: 'Календарь',
              pageName: 'calendar',
            ),
          ),
          Expanded(
            child: _buildBottomBarItem(
              icon: Icons.home,
              text: 'Главная',
              pageName: 'main',
            ),
          ),
          Expanded(
            child: _buildBottomBarItem(
              icon: Icons.assignment,
              text: 'Задания',
              pageName: 'tasks',
            ),
          ),
        ],
      ),
    );
  }





  Widget _buildBottomBarItem({
    required IconData icon,
    required String text,
    required String pageName,
  }) {
    final bool isSelected = pageName == currentPage;
    final Color selectorColor = isSelected ? FigmaColors.selectorColor : FigmaColors.darkBlueMain;

    return InkWell(
      onTap: () {
        // Обработка нажатия на кнопку
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: selectorColor,
          ),
          SizedBox(height: 4),
          CustomText(
            text: text,
            style: TextStyle(
              color: selectorColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
