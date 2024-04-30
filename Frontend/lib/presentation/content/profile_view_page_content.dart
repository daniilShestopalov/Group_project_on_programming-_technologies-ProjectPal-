import 'package:project_pal/core/app_export.dart';

class ProfileViewPageContent extends StatefulWidget {
  final int userId;

  const ProfileViewPageContent({Key? key, required this.userId}) : super(key: key);

  @override
  _ProfilePageContentState createState() => _ProfilePageContentState();
}

class _ProfilePageContentState extends State<ProfileViewPageContent> {
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Center(
            child: CircleAvatar(
              radius: 75,
              backgroundColor: FigmaColors.contrastToMain,
              child: Text(
                DataUtils.getUserInitialsById(widget.userId),
                style: TextStyle(fontSize: 48),
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomTextField(
                hintText: DataUtils.getUserNameById(widget.userId),
                figmaTextStyles: figmaTextStyles,
                enabled: isEditing,
              ),
              SizedBox(height: 16),
              CustomTextField(
                hintText: DataUtils.getUserSurnameById(widget.userId),
                figmaTextStyles: figmaTextStyles,
                enabled: isEditing,
              ),
              SizedBox(height: 16),
              CustomTextField(
                hintText: DataUtils.getUserPatronymicById(widget.userId),
                figmaTextStyles: figmaTextStyles,
                enabled: isEditing,
              ),
              SizedBox(height: 16),
              CustomTextField(
                hintText: DataUtils.getUserEmailById(widget.userId),
                figmaTextStyles: figmaTextStyles,
                enabled: isEditing,
              ),
              SizedBox(height: 16),
              CustomTextField(
                hintText: DataUtils.getRoleName(DataUtils.getUserRoleById(widget.userId)),
                figmaTextStyles: figmaTextStyles,
                enabled: isEditing,
              ),
              SizedBox(height: 16),
              CustomTextField(
                hintText: 'Группа ' + DataUtils.getUserGroupIdById(widget.userId),
                figmaTextStyles: figmaTextStyles,
                enabled: isEditing,
              ),
            ],
          ),
        ),
        SizedBox(height: 36),
        CustomButton(
            text: 'Оставить жалобу',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => Theme(
                  data: Theme.of(context).copyWith(dialogBackgroundColor: FigmaColors.whiteBackground),
                  child: AlertDialog (
                  title: Text('Жалоба подана'),
                  content: Text('Администратор рассмотрит вашу жалобу в ближайшее время'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('OK'),
                    ),
                  ],
                  ),
                ),
              );
            }, figmaTextStyles: figmaTextStyles
        )
      ],
    );
  }
}
