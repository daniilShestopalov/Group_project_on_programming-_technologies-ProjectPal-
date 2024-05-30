import 'package:project_pal/core/app_export.dart';

class TaskBlockOpenCreateWidget extends StatefulWidget {
  final String? subject;
  final String? date;
  final String? teacher;
  final int userId;
  final String? instruction;
  final String? grade;
  final String? comment;
  final int taskId;

  TaskBlockOpenCreateWidget({
    required this.subject,
    required this.date,
    required this.teacher,
    required this.userId,
    required this.instruction,
    this.grade,
    this.comment, required this.taskId,
  });

  @override
  _TaskBlockOpenCreateWidgetState createState() => _TaskBlockOpenCreateWidgetState();
}

class _TaskBlockOpenCreateWidgetState extends State<TaskBlockOpenCreateWidget> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _fileLinkController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  final ApiService apiService = ApiService();
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();
  bool isEditing = false;
  late User user;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // Добавьте оператор return здесь
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomTextField(
                  hintText: _nameController.text.isNotEmpty ? _nameController.text : 'Название предмета',
                  controller: _nameController,
                  figmaTextStyles: figmaTextStyles,
                  enabled: isEditing,
                ),
                SizedBox(height: 16),
                CustomTextField(
                  hintText: _descriptionController.text.isNotEmpty ? _descriptionController.text : 'Описание задания',
                  controller: _descriptionController,
                  figmaTextStyles: figmaTextStyles,
                  enabled: isEditing,
                ),
                SizedBox(height: 16),
                CustomTextField(
                  hintText: _dateController.text,
                  controller: _dateController,
                  figmaTextStyles: figmaTextStyles,
                  enabled: isEditing,
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
          SizedBox(height: 36),
          CustomButton(
            text: (isEditing ? 'Сохранить' : 'Изменить данные'),
            onPressed: () async {
              setState(() {
                isEditing = !isEditing; // Изменить состояние isEditing при нажатии на кнопку
              });
              if (isEditing) {
                String? token = await apiService.getJwtToken();
                if (token != null) {
                  print('Token for updating user: $token'); // Debug print
                  print('User updated successfully'); // Debug print
                } else {
                  print('Failed to retrieve token for updating user');
                }
              }
            },
            figmaTextStyles: figmaTextStyles,
          ),
          SizedBox(height: 16),
          CustomButton(
            text: 'Отправить задачу',
            onPressed: () async {

            },
            figmaTextStyles: figmaTextStyles,
          ),
          SizedBox(height: 36),
        ],
      ),
    );
  }
}

