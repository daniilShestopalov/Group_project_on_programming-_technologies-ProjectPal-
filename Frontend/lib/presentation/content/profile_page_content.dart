import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:project_pal/core/app_export.dart';

class ProfilePageContent extends StatefulWidget {
  final int userId;

  const ProfilePageContent({Key? key, required this.userId}) : super(key: key);

  @override
  _ProfilePageContentState createState() => _ProfilePageContentState();
}

class _ProfilePageContentState extends State<ProfilePageContent> {
  final ApiService apiService = ApiService();
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();
  bool isEditing = false;
  File? _image;
  late User user;
  TextEditingController _loginController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();
  TextEditingController _patronymicController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _roleController = TextEditingController();
  TextEditingController _groupIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final token = await apiService.getJwtToken();

      if (token != null) {
        print('Token received: $token'); // Debug print
        user = await apiService.getUserById(token, widget.userId);
        File? image = await apiService.downloadAvatar(token, user.avatarLink);
        Group group = await apiService.getGroupById(token, user.groupId!);
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
        print('User data received: ${user.toJson()}'); // Debug print
        setState(() {
          _image = image;
          _loginController.text = user.login;
          _nameController.text = user.name;
          _surnameController.text = user.surname;
          _patronymicController.text = user.patronymic;
          _phoneNumberController.text = user.phoneNumber;
          _roleController.text = userRole; // Используем роль пользователя из данных
          _groupIdController.text = '${group.groupNumber}'; // Преобразуем groupId в строку
        });
      } else {
        print('Failed to retrieve token');
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<void> getImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        print('Image selected: ${pickedFile.path}'); // Debug print
        final token = await apiService.getJwtToken();

        if (token != null) {
          try {
            // Загружаем выбранное изображение на сервер в качестве аватара
            await apiService.updateUserAvatar(token, widget.userId, pickedFile.name);
            print('pickedFile.name');
            await apiService.uploadAvatar(token, File(pickedFile.path));
            print('pickedFile.path'); // Debug print

            setState(() {
              _image = File(pickedFile.path); // Обновляем состояние после успешной загрузки и обновления аватара
            });
          } catch (e) {
            print('Error uploading avatar: $e');
          }
        } else {
          print('Failed to retrieve token');
        }
      } else {
        print('No image selected.');
      }

      setState(() {
        // Обновляем состояние после изменения изображения
      });
    } catch (e) {
      print('Error getting image: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return _loginController.text.isNotEmpty // Проверяем, загружены ли данные пользователя
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
                    getImage();
                  }
                },
                child: CircleAvatar(
                  radius: 75,
                  backgroundColor: FigmaColors.contrastToMain,
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null
                      ? Text(
                    '${_nameController.text[0].toUpperCase()}',
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
                CustomText(text: "Почта", style: figmaTextStyles.caption1Medium.copyWith(color: FigmaColors.darkBlueMain), align: TextAlign.center,),
                SizedBox(height: 5),
                CustomTextField(
                  hintText: _loginController.text,
                  controller: _loginController,
                  figmaTextStyles: figmaTextStyles,
                  enabled: isEditing,
                ),
                SizedBox(height: 16),
                CustomText(text: "Имя", style: figmaTextStyles.caption1Medium.copyWith(color: FigmaColors.darkBlueMain), align: TextAlign.center,),
                SizedBox(height: 5),
                CustomTextField(
                  hintText: _nameController.text,
                  controller: _nameController,
                  figmaTextStyles: figmaTextStyles,
                  enabled: isEditing,
                ),
                SizedBox(height: 16),
                CustomText(text: "Фамилия", style: figmaTextStyles.caption1Medium.copyWith(color: FigmaColors.darkBlueMain), align: TextAlign.center,),
                SizedBox(height: 5),
                CustomTextField(
                  hintText: _surnameController.text,
                  controller: _surnameController,
                  figmaTextStyles: figmaTextStyles,
                  enabled: isEditing,
                ),
                SizedBox(height: 16),
                CustomText(text: "Отчество", style: figmaTextStyles.caption1Medium.copyWith(color: FigmaColors.darkBlueMain), align: TextAlign.center,),
                SizedBox(height: 5),
                CustomTextField(
                  hintText: _patronymicController.text,
                  controller: _patronymicController,
                  figmaTextStyles: figmaTextStyles,
                  enabled: isEditing,
                ),
                SizedBox(height: 16),
                CustomText(text: "Номер телефона", style: figmaTextStyles.caption1Medium.copyWith(color: FigmaColors.darkBlueMain), align: TextAlign.center,),
                SizedBox(height: 5),
                CustomTextField(
                  hintText: _phoneNumberController.text,
                  controller: _phoneNumberController,
                  figmaTextStyles: figmaTextStyles,
                  enabled: isEditing,
                ),
                SizedBox(height: 16),
                CustomText(text: "Роль", style: figmaTextStyles.caption1Medium.copyWith(color: FigmaColors.darkBlueMain), align: TextAlign.center,),
                SizedBox(height: 5),
                CustomTextField(
                  hintText: _roleController.text,
                  controller: _roleController,
                  figmaTextStyles: figmaTextStyles,
                  enabled: false,
                ),
                SizedBox(height: 16),
                CustomText(text: "Номер группы", style: figmaTextStyles.caption1Medium.copyWith(color: FigmaColors.darkBlueMain), align: TextAlign.center,),
                SizedBox(height: 5),
                CustomTextField(
                  hintText: _groupIdController.text,
                  controller: _groupIdController,
                  figmaTextStyles: figmaTextStyles,
                  enabled: false,
                ),
              ],
            ),
          ),
          SizedBox(height: 36),
          CustomButton(
            text: (isEditing ? 'Сохранить' : 'Изменить данные'),
            onPressed: () async {
              if (isEditing) {
                String? token = await apiService.getJwtToken();
                if (token != null) {
                  print('Token for updating user: $token'); // Debug print
                  try {
                    await apiService.updateUserWithoutPassword(
                      id: widget.userId,
                      login: _loginController.text,
                      name: _nameController.text,
                      surname: _surnameController.text,
                      patronymic: _patronymicController.text,
                      phoneNumber: _phoneNumberController.text,
                      avatarLink: _image != null ? _image!.path.split('/').last : '',
                      role: user.role,
                      groupId: user.groupId!,
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
        : Center(child: CircularProgressIndicator());
  }
}
