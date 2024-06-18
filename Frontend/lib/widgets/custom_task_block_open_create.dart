import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:project_pal/core/app_export.dart';

class TaskBlockOpenCreateWidget extends StatefulWidget {
  final String? subject;
  final DateTime? endDate;
  final DateTime? startDate;
  final String? teacher;
  final int userId;
  final String? instruction;
  final String? grade;
  final String? comment;
  final int taskId;
  final String? fileLink;

  TaskBlockOpenCreateWidget({
    required this.subject,
    required this.endDate,
    required this.startDate,
    required this.teacher,
    required this.userId,
    required this.instruction,
    this.grade,
    this.comment,
    this.fileLink,
    required this.taskId,
  });

  @override
  _TaskBlockOpenCreateWidgetState createState() => _TaskBlockOpenCreateWidgetState();
}

class _TaskBlockOpenCreateWidgetState extends State<TaskBlockOpenCreateWidget> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _fileLink = TextEditingController();

  final ApiService apiService = ApiService();
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  bool isEditing = false;
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  List<Group> _groups = [];
  Group? _selectedGroup;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.subject ?? '';
    _descriptionController.text = widget.instruction ?? '';
    _endDateController.text = widget.endDate != null ? dateFormat.format(widget.endDate!) : '';
    _startDateController.text = widget.startDate != null ? dateFormat.format(widget.startDate!) : '';
    _selectedEndDate = widget.endDate;
    _fileLink.text = widget.fileLink ?? '';
    _fetchGroups();
  }

  Future<void> _fetchGroups() async {
    String? token = await apiService.getJwtToken();
    if (token != null) {
      try {
        List<Group> groups = await apiService.fetchGroups(token);
        setState(() {
          _groups = groups;
        });
      } catch (e) {
        print('Failed to fetch groups: $e');
      }
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: (isStartDate ? _selectedStartDate : _selectedEndDate) ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _selectedStartDate = pickedDate;
          _startDateController.text = dateFormat.format(_selectedStartDate!);
        } else {
          _selectedEndDate = pickedDate;
          _endDateController.text = dateFormat.format(_selectedEndDate!);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: CustomText(
                    text: "Название предмета",
                    style: figmaTextStyles.caption1Medium.copyWith(color: FigmaColors.darkBlueMain),
                    align: TextAlign.center,
                  ),
                ),
                CustomTextField(
                  hintText: '',
                  controller: _nameController,
                  figmaTextStyles: figmaTextStyles,
                  enabled: isEditing,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: CustomText(
                        text: "Дата начала",
                        style: figmaTextStyles.caption1Medium.copyWith(color: FigmaColors.darkBlueMain),
                        align: TextAlign.center,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: isEditing ? () {
                        _selectDate(context, true);
                      } : null,
                    ),
                  ],
                ),
                CustomTextField(
                  hintText: '',
                  controller: _startDateController,
                  figmaTextStyles: figmaTextStyles,
                  enabled: isEditing,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: CustomText(
                        text: "Дата сдачи",
                        style: figmaTextStyles.caption1Medium.copyWith(color: FigmaColors.darkBlueMain),
                        align: TextAlign.center,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: isEditing ? () {
                        _selectDate(context, false);
                      } : null,
                    ),
                  ],
                ),
                CustomTextField(
                  hintText: '',
                  controller: _endDateController,
                  figmaTextStyles: figmaTextStyles,
                  enabled: isEditing,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: CustomText(
                    text: "Описание задачи",
                    style: figmaTextStyles.caption1Medium.copyWith(color: FigmaColors.darkBlueMain),
                    align: TextAlign.center,
                  ),
                ),
                CustomTextField(
                  hintText: '',
                  maxLines: 10,
                  controller: _descriptionController,
                  figmaTextStyles: figmaTextStyles,
                  enabled: isEditing,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: CustomText(
                    text: "Выберите группу",
                    style: figmaTextStyles.caption1Medium.copyWith(color: FigmaColors.darkBlueMain),
                    align: TextAlign.center,
                  ),
                ),
                DropdownButton<Group>(
                  hint: Text("Выберите группу"),
                  value: _selectedGroup,
                  items: _groups.map((Group group) {
                    return DropdownMenuItem<Group>(
                      value: group,
                      child: Text('Группа '+'${group.groupNumber.toString()}' + ' Курс ' + '${group.courseNumber.toString()}'),
                    );
                  }).toList(),
                  onChanged: isEditing ? (Group? newValue) {
                    setState(() {
                      _selectedGroup = newValue!;
                    });
                  } : null,
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: CustomText(
                    text: "Название файла",
                    style: figmaTextStyles.caption1Medium.copyWith(color: FigmaColors.darkBlueMain),
                    align: TextAlign.center,
                  ),
                ),
                CustomTextField(
                  hintText: '',
                  maxLines: 1,
                  controller: _fileLink,
                  figmaTextStyles: figmaTextStyles,
                  enabled: isEditing,
                ),
                SizedBox(height: 16),
                CustomButton(
                  text: 'Прикрепить ответ',
                  onPressed: () async {
                    FilePickerResult? result =
                    await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['pdf'],
                    );
                    if (result != null && result.files.isNotEmpty) {
                      try {
                        String token = await apiService.getJwtToken() ?? '';
                        String filePath = result.files.first.path!;
                        File file = File(filePath);
                        _fileLink.text = file.path.split('/').last;
                        await apiService.uploadTaskFile(token, file, widget.taskId);
                      } catch (e) {
                        print('Error uploading file: $e');
                      }
                    } else {
                      print('No file selected');
                    }
                  },
                  figmaTextStyles: figmaTextStyles,
                  showArrows: false,
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
              String? token = await apiService.getJwtToken();
              if (token != null && _selectedEndDate != null) {
               int? taskId = await apiService.createTask(
                  token: token,
                  taskId: widget.taskId,
                  name: _nameController.text,
                  teacherUserId: widget.userId,
                  groupId: _selectedGroup?.id ?? 0,
                  description: _descriptionController.text,
                  fileLink: _fileLink.text,
                  startDate: _selectedStartDate ?? DateTime.now(),
                  endDate: _selectedEndDate!,
                );
                final students = await apiService.getUsersByGroup(_selectedGroup!.id, token);
                for (var student in students) {
                  await apiService.createTaskAnswer(token: token,
                    taskId: taskId!,
                    id: 0,
                    studentUserId: student.id,
                    submissionDate: DateTime.now(),
                    teacherCommentary: '',
                    studentCommentary: '',
                    grade: 0,
                    fileLink: ''
                );}

                AppRoutes.navigateToPageWithFadeTransition(context, TasksPage(userId: widget.userId));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Задание создано'),
                  ),
                );
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
