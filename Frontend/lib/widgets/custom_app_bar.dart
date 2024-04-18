import 'package:project_pal/core/app_export.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onMenuPressed;
  final VoidCallback? onProfilePressed;

  const CustomAppBar({
    Key? key,
    this.onMenuPressed,
    this.onProfilePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: onMenuPressed,
      ),
      centerTitle: true,
      title: Image.asset(
        ImageConstant.smallIcon,
        width: 40,
        height: 40,
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.account_circle),
          onPressed: onProfilePressed,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
