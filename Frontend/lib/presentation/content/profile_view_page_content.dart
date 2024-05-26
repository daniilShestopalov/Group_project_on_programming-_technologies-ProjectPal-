import 'dart:io';
import 'package:image_picker/image_picker.dart';
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
        setState(() {
          _user = user;
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
        final token = await apiService.getJwtToken();

        if (token != null) {
          try {
            // Обновляем аватар пользователя на сервере
            await apiService.updateUserAvatar(token, widget.userViewId, pickedFile.name);

            // Загружаем выбранное изображение на сервер в качестве аватара
            await apiService.uploadAvatar(token, File(pickedFile.path));

            // Если нужно, можете использовать uploadedFilename для чего-то еще

            setState(() {
              // Обновляем состояние после успешной загрузки и обновления аватара
            });
          } catch (e) {
            print('Error uploading or updating avatar: $e');
            // Показываем сообщение об ошибке пользователю
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
    return _user != null
        ? Column(
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
                  DataUtils.getUserInitialsById(widget.userId),
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
              CustomTextField(
                hintText: _user!.login,
                figmaTextStyles: figmaTextStyles,
                enabled: isEditing,
              ),
              SizedBox(height: 16),
              CustomTextField(
                hintText: _user!.surname,
                figmaTextStyles: figmaTextStyles,
                enabled: isEditing,
              ),
              SizedBox(height: 16),
              CustomTextField(
                hintText: _user!.patronymic,
                figmaTextStyles: figmaTextStyles,
                enabled: isEditing,
              ),
              SizedBox(height: 16),
              CustomTextField(
                hintText: _user!.phoneNumber,
                figmaTextStyles: figmaTextStyles,
                enabled: isEditing,
              ),
              SizedBox(height: 16),
              CustomTextField(
                hintText: DataUtils.getRoleName(_user!.role),
                figmaTextStyles: figmaTextStyles,
                enabled: isEditing,
              ),
              SizedBox(height: 16),
              CustomTextField(
                hintText: 'Группа ' + _user!.groupId.toString(),
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
        )
      ],
    )
        : CircularProgressIndicator(); // Добавлен индикатор загрузки пока данные загружаются
  }
}
