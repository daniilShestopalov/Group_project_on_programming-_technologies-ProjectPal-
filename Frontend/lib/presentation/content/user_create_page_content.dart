import 'package:project_pal/core/app_export.dart';

class UserCreatePageContent extends StatefulWidget {
  final int userId;

  const UserCreatePageContent({Key? key, required this.userId}) : super(key: key);

  @override
  _UserCreatePageContentState createState() => _UserCreatePageContentState();
}

class _UserCreatePageContentState extends State<UserCreatePageContent> {
  final ApiService apiService = ApiService();
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();
  bool isEditing = false;
  TextEditingController _loginController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();
  TextEditingController _patronymicController = TextEditingController();
  TextEditingController _roleController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Center(
              child: GestureDetector(
                onTap: () {
                },
                child: CircleAvatar(
                  radius: 75,
                  backgroundColor: FigmaColors.contrastToMain,
                  child:  Text(
                    '${_nameController.text.isNotEmpty ? _nameController.text[0].toUpperCase() : ''}${_surnameController.text.isNotEmpty ? _surnameController.text[0].toUpperCase() : ''}',
                    style: TextStyle(fontSize: 48),
                  )
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
                CustomText(
                  text: "Временный логин",
                  style: figmaTextStyles.caption1Medium
                      .copyWith(color: FigmaColors.darkBlueMain),
                  align: TextAlign.center,
                ),
                SizedBox(height: 5),
                CustomTextField(
                  hintText: _loginController.text,
                  controller: _loginController,
                  figmaTextStyles: figmaTextStyles,
                  enabled: isEditing,
                ),
                SizedBox(height: 16),
                CustomText(
                  text: "Временный пароль",
                  style: figmaTextStyles.caption1Medium
                      .copyWith(color: FigmaColors.darkBlueMain),
                  align: TextAlign.center,
                ),
                SizedBox(height: 5),
                CustomTextField(
                  hintText: _passwordController.text,
                  controller: _passwordController,
                  figmaTextStyles: figmaTextStyles,
                  enabled: isEditing,
                ),
                SizedBox(height: 16),
                CustomText(
                  text: "Имя",
                  style: figmaTextStyles.caption1Medium
                      .copyWith(color: FigmaColors.darkBlueMain),
                  align: TextAlign.center,
                ),
                SizedBox(height: 5),
                CustomTextField(
                  hintText: _nameController.text,
                  controller: _nameController,
                  figmaTextStyles: figmaTextStyles,
                  enabled: isEditing,
                ),
                SizedBox(height: 16),
                CustomText(
                  text: "Фамилия",
                  style: figmaTextStyles.caption1Medium
                      .copyWith(color: FigmaColors.darkBlueMain),
                  align: TextAlign.center,
                ),
                SizedBox(height: 5),
                CustomTextField(
                  hintText: _surnameController.text,
                  controller: _surnameController,
                  figmaTextStyles: figmaTextStyles,
                  enabled: isEditing,
                ),
                SizedBox(height: 16),
                CustomText(
                  text: "Отчество",
                  style: figmaTextStyles.caption1Medium
                      .copyWith(color: FigmaColors.darkBlueMain),
                  align: TextAlign.center,
                ),
                SizedBox(height: 5),
                CustomTextField(
                  hintText: _patronymicController.text,
                  controller: _patronymicController,
                  figmaTextStyles: figmaTextStyles,
                  enabled: isEditing,
                ),
                SizedBox(height: 16),
                CustomText(
                  text: "Роль",
                  style: figmaTextStyles.caption1Medium
                      .copyWith(color: FigmaColors.darkBlueMain),
                  align: TextAlign.center,
                ),
                SizedBox(height: 5),
                CustomTextField(
                  hintText: _roleController.text,
                  controller: _roleController,
                  figmaTextStyles: figmaTextStyles,
                  enabled: isEditing,
                ),
                SizedBox(height: 16),
                SizedBox(height: 5),
              ],
            ),
          ),
          SizedBox(height: 36),
          CustomButton(
            text: (isEditing ? 'Создать' : 'Ввести данные'),
            onPressed: () async {
              if (isEditing) {
                String? token = await apiService.getJwtToken();
                if (token != null) {
                  print('Token for updating user: $token'); // Debug print
                  try {
                    await apiService.createUser(
                      id: 0,
                      login: _loginController.text,
                      name: _nameController.text,
                      surname: _surnameController.text,
                      patronymic: _patronymicController.text,
                      phoneNumber: '',
                      avatarLink: '',
                      role: _roleController.text,
                      groupId: null,
                      token: token,
                      password: _passwordController.text,
                    );
                    setState(() {
                      isEditing = false;
                    });
                    print('User updated successfully');
                    // Debug print
                  } catch (e) {
                    print('Error updating user: $e');
                  }
                } else {
                  print('Failed to retrieve token for updating user');
                }
              } else {
                setState(() {
                  isEditing = true;
                });
              }
            },
            figmaTextStyles: figmaTextStyles,
          ),
          SizedBox(height: 36),
        ],
      ),
    );
  }
}
