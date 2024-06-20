import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:project_pal/core/app_export.dart';

class ProjectBlockOpenCreateWidget extends StatefulWidget {
  final String? subject;
  final DateTime? endDate;
  final DateTime? startDate;
  final String? teacher;
  final int userId;
  final String? instruction;
  final String? grade;
  final String? comment;
  final int projectId;
  final String? fileLink;

  ProjectBlockOpenCreateWidget({
    required this.subject,
    required this.endDate,
    required this.startDate,
    required this.teacher,
    required this.userId,
    required this.instruction,
    this.grade,
    this.comment,
    this.fileLink,
    required this.projectId,
  });

  @override
  _ProjectBlockOpenCreateWidgetState createState() =>
      _ProjectBlockOpenCreateWidgetState();
}

class _ProjectBlockOpenCreateWidgetState
    extends State<ProjectBlockOpenCreateWidget> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _fileLink = TextEditingController();
  TextEditingController _searchController = TextEditingController();

  final ApiService apiService = ApiService();
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  bool isEditing = true;
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  List<User> allStudents = [];
  List<User> filteredStudents = [];
  Set<int> selectedStudentIds = Set<int>();
  bool isStudentListExpanded = false;
  List<User> students = []; // Added to store selected students
  Map<int, Group?> userGroups =
      {}; // Store fetched groups to avoid multiple calls

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.subject ?? '';
    _descriptionController.text = widget.instruction ?? '';
    _endDateController.text =
        widget.endDate != null ? dateFormat.format(widget.endDate!) : '';
    _startDateController.text =
        widget.startDate != null ? dateFormat.format(widget.startDate!) : '';
    _selectedEndDate = widget.endDate;
    _fileLink.text = widget.fileLink ?? '';
    _fetchUsers();
    _searchController.addListener(_filterStudents);
  }

  Future<void> _fetchUsers() async {
    String? token = await apiService.getJwtToken();
    if (token != null) {
      try {
        List<User> users = await apiService.getUsersByRole('student', token);
        setState(() {
          allStudents = users;
          filteredStudents = users;
        });
      } catch (e) {
        print('Failed to fetch users: $e');
      }
    }
  }

  void _toggleStudentSelection(User student, bool selected) {
    if (selected) {
      setState(() {
        selectedStudentIds.add(student.id);
        students.add(student);
      });
    } else {
      setState(() {
        selectedStudentIds.remove(student.id);
        students.remove(student);
      });
    }
  }

  void _filterStudents() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredStudents = allStudents.where((student) {
        return student.name.toLowerCase().contains(query) ||
            student.surname.toLowerCase().contains(query) ||
            student.patronymic.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<Group?> _fetchGroup(int groupId) async {
    if (userGroups.containsKey(groupId)) {
      return userGroups[groupId];
    }

    String? token = await apiService.getJwtToken();
    if (token != null) {
      try {
        Group group = await apiService.getGroupById(token, groupId);
        userGroups[groupId] = group;
        return group;
      } catch (e) {
        print('Failed to fetch group: $e');
        return null;
      }
    }
    return null;
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: (isStartDate ? _selectedStartDate : _selectedEndDate) ??
          DateTime.now(),
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
        // Clear the list of selected students when dates change
        students.clear();
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
                    style: figmaTextStyles.caption1Medium
                        .copyWith(color: FigmaColors.darkBlueMain),
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
                        style: figmaTextStyles.caption1Medium
                            .copyWith(color: FigmaColors.darkBlueMain),
                        align: TextAlign.center,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: isEditing
                          ? () {
                              _selectDate(context, true);
                            }
                          : null,
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
                        style: figmaTextStyles.caption1Medium
                            .copyWith(color: FigmaColors.darkBlueMain),
                        align: TextAlign.center,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: isEditing
                          ? () {
                              _selectDate(context, false);
                            }
                          : null,
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
                    style: figmaTextStyles.caption1Medium
                        .copyWith(color: FigmaColors.darkBlueMain),
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
                  child: ExpansionTile(
                    title: Text(
                      "Список студентов",
                      style: figmaTextStyles.caption1Medium
                          .copyWith(color: FigmaColors.darkBlueMain),
                    ),
                    initiallyExpanded: isStudentListExpanded,
                    onExpansionChanged: (bool expanded) {
                      setState(() => isStudentListExpanded = expanded);
                    },
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          "Поиск студентов",
                          style: figmaTextStyles.caption1Medium
                              .copyWith(color: FigmaColors.darkBlueMain),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      TextField(
                        decoration: InputDecoration(
                            hintText: 'Введите имя, фамилию или отчество'),
                        maxLines: 1,
                        controller: _searchController,
                        enabled: true,
                      ),
                      SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: filteredStudents.length,
                        itemBuilder: (context, index) {
                          User student = filteredStudents[index];
                          return ListTile(
                            title: Text(
                                '${student.name} ${student.surname} ${student.patronymic}'),
                            subtitle: FutureBuilder<Group?>(
                              future: _fetchGroup(student.groupId ?? 0),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Text('Загрузка...');
                                } else if (snapshot.hasError ||
                                    snapshot.data == null) {
                                  return Text('Ошибка загрузки данных группы');
                                } else {
                                  Group group = snapshot.data!;
                                  return Text(
                                      'Группа: ${group.groupNumber}, Курс: ${group.courseNumber}');
                                }
                              },
                            ),
                            trailing: Checkbox(
                              value: selectedStudentIds.contains(student.id),
                              onChanged: (bool? value) {
                                _toggleStudentSelection(
                                    student, value ?? false);
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: CustomText(
                    text: "Название файла",
                    style: figmaTextStyles.caption1Medium
                        .copyWith(color: FigmaColors.darkBlueMain),
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
                        await apiService.uploadProjectFile(
                            token, file, widget.projectId);
                      } catch (e) {
                        print('Error uploading file: $e');
                      }
                    } else {
                      print('No file selected');
                    }
                  },
                  text: 'Прикрепить файл задания',
                  figmaTextStyles: figmaTextStyles,
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
          SizedBox(height: 42),
          CustomButton(
            onPressed: () async {
              String? token = await apiService.getJwtToken();
              if (token != null && _selectedEndDate != null) {
                int? projectId = await apiService.createProject(
                  token: token,
                  id: widget.projectId,
                  name: _nameController.text,
                  teacherId: widget.userId,
                  description: _descriptionController.text,
                  fileLink: _fileLink.text,
                  startDate: _selectedStartDate ?? DateTime.now(),
                  endDate: _selectedEndDate!,
                );

                await apiService.createProjectAnswer
                  (token: token,
                    projectId: projectId!,
                    id: 0,
                    submissionDate: DateTime.now(),
                    teacherCommentary: '',
                    studentCommentary: '',
                    grade: 0,
                    fileLink: '');
                // Use 'students' list here to create student projects
                for (var student in students) {
                  await apiService.createStudentProject(
                    token: token,
                    id: 0,
                    studentUserId: student.id,
                    projectId: projectId,
                  );
                }

                AppRoutes.navigateToPageWithFadeTransition(
                  context,
                  ProjectPage(userId: widget.userId),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Задание создано'),
                  ),
                );
              }
            },
            text: 'Создать проект',
            figmaTextStyles: figmaTextStyles,
          ),
          SizedBox(height: 36),
        ],
      ),
    );
  }
}
