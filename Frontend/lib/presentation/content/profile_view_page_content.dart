import 'dart:io';
import 'package:flutter/material.dart';
import 'package:project_pal/core/app_export.dart';

class ProfileViewPageContent extends StatefulWidget {
  final int userId;
  final int userViewId;

  const ProfileViewPageContent({Key? key, required this.userId, required this.userViewId}) : super(key: key);

  @override
  _ProfileViewPageContentState createState() => _ProfileViewPageContentState();
}

class _ProfileViewPageContentState extends State<ProfileViewPageContent> {
  final ApiService apiService = ApiService();
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();
  bool isEditing = false;
  File? _image;
  User? _user;
  User? _admin;
  String role = '';
  TextEditingController _loginController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();
  TextEditingController _patronymicController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final token = await apiService.getJwtToken();
      if (token != null) {
        final user = await apiService.getUserById(token, widget.userViewId);
        final admin = await apiService.getUserById(token, widget.userId);

        File? image;
        image = await apiService.downloadAvatar(token, user.id, user.avatarLink);

        String userRole = '';
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
        setState(() {
          _image = image;
          _user = user;
          _admin = admin;
          role = userRole;
          _loginController.text = user.login ?? '';
          _nameController.text = user.name ?? '';
          _surnameController.text = user.surname ?? '';
          _patronymicController.text = user.patronymic ?? '';
          _phoneNumberController.text = user.phoneNumber ?? '';
        });
      } else {
        print('Failed to retrieve token');
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return _user != null
        ? SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  if (isEditing) {
                    // Добавить функциональность для изменения аватара
                  }
                },
                child: CircleAvatar(
                  radius: 75,
                  backgroundColor: FigmaColors.contrastToMain,
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null
                      ? Text(
                    '${_user?.surname[0].toUpperCase()}${_user?.name[0].toUpperCase()}',
                    style: TextStyle(fontSize: 48),
                  )
                      : null,
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
                  text: "Почта",
                  style: figmaTextStyles.caption1Medium.copyWith(color: FigmaColors.darkBlueMain),
                  align: TextAlign.center,
                ),
                SizedBox(height: 5),
                CustomTextField(
                  controller: _loginController,
                  hintText: _user!.login,
                  figmaTextStyles: figmaTextStyles,
                  enabled: isEditing,
                ),
                SizedBox(height: 16),
                CustomText(
                  text: "Имя",
                  style: figmaTextStyles.caption1Medium.copyWith(color: FigmaColors.darkBlueMain),
                  align: TextAlign.center,
                ),
                SizedBox(height: 5),
                CustomTextField(
                  controller: _nameController,
                  hintText: _user!.name,
                  figmaTextStyles: figmaTextStyles,
                  enabled: isEditing,
                ),
                SizedBox(height: 16),
                CustomText(
                  text: "Фамилия",
                  style: figmaTextStyles.caption1Medium.copyWith(color: FigmaColors.darkBlueMain),
                  align: TextAlign.center,
                ),
                SizedBox(height: 5),
                CustomTextField(
                  controller: _surnameController,
                  hintText: _user!.surname,
                  figmaTextStyles: figmaTextStyles,
                  enabled: isEditing,
                ),
                SizedBox(height: 16),
                CustomText(
                  text: "Отчество",
                  style: figmaTextStyles.caption1Medium.copyWith(color: FigmaColors.darkBlueMain),
                  align: TextAlign.center,
                ),
                SizedBox(height: 5),
                CustomTextField(
                  controller: _patronymicController,
                  hintText: _user!.patronymic,
                  figmaTextStyles: figmaTextStyles,
                  enabled: isEditing,
                ),
                SizedBox(height: 16),
                CustomText(
                  text: "Номер телефона",
                  style: figmaTextStyles.caption1Medium.copyWith(color: FigmaColors.darkBlueMain),
                  align: TextAlign.center,
                ),
                SizedBox(height: 5),
                CustomTextField(
                  controller: _phoneNumberController,
                  hintText: _user!.phoneNumber,
                  figmaTextStyles: figmaTextStyles,
                  enabled: isEditing,
                ),
                SizedBox(height: 16),
                CustomText(
                  text: "Роль",
                  style: figmaTextStyles.caption1Medium.copyWith(color: FigmaColors.darkBlueMain),
                  align: TextAlign.center,
                ),
                SizedBox(height: 5),
                CustomTextField(
                  hintText: role,
                  figmaTextStyles: figmaTextStyles,
                  enabled: false,
                ),
                SizedBox(height: 16),
                if (role == 'Студент')
                  Column(
                    children: [
                      CustomText(
                        text: "Номер группы",
                        style: figmaTextStyles.caption1Medium.copyWith(color: FigmaColors.darkBlueMain),
                        align: TextAlign.center,
                      ),
                      SizedBox(height: 5),
                      CustomTextField(
                        hintText: 'Группа ' + (_user!.groupId?.toString() ?? ''),
                        figmaTextStyles: figmaTextStyles,
                        enabled: false,
                      ),
                    ],
                  ),
              ],
            ),
          ),
          SizedBox(height: 36),
          if (_admin!.role != 'ADMIN')
            CustomButton(
              text: 'Оставить жалобу',
              onPressed: () async {
                String? token = await apiService.getJwtToken();
                await apiService.createComplaint(token!, widget.userId, widget.userViewId);
                showDialog(
                  context: context,
                  builder: (context) => Theme(
                    data: Theme.of(context).copyWith(dialogBackgroundColor: FigmaColors.whiteBackground),
                    child: AlertDialog(
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
              },
              figmaTextStyles: figmaTextStyles,
            ),
          if (_admin!.role == 'ADMIN')
            CustomButton(
              text: (isEditing ? 'Сохранить' : 'Изменить данные'),
              onPressed: () async {
                if (isEditing) {
                  String? token = await apiService.getJwtToken();
                  if (token != null) {
                    print('Token for updating user: $token'); // Debug print
                    try {
                      await apiService.updateUserWithoutPassword(
                        id: widget.userViewId,
                        login: _loginController.text,
                        name: _nameController.text,
                        surname: _surnameController.text,
                        patronymic: _patronymicController.text,
                        phoneNumber: _phoneNumberController.text,
                        avatarLink: _image != null ? _image!.path.split('/').last : '',
                        role: _user!.role,
                        groupId: _user?.groupId ?? null,
                        token: token,
                      );
                      setState(() {
                        isEditing = false;
                      });
                      print('User updated successfully'); // Debug print
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
    )
        : Center(
      child: CircularProgressIndicator(),
    );
  }
}
