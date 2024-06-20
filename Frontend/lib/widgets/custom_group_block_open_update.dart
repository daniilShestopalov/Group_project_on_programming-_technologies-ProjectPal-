import 'package:project_pal/core/app_export.dart';

class GroupBlockOpenUpdateWidget extends StatefulWidget {
  final int userId;
  final int groupId;

  GroupBlockOpenUpdateWidget({
    required this.userId,
    required this.groupId,
  });

  @override
  _GroupBlockOpenUpdateWidgetState createState() => _GroupBlockOpenUpdateWidgetState();
}

class _GroupBlockOpenUpdateWidgetState extends State<GroupBlockOpenUpdateWidget> {
  TextEditingController _numberController = TextEditingController();
  TextEditingController _courseNubmerController = TextEditingController();
  TextEditingController _searchController = TextEditingController();

  final ApiService apiService = ApiService();
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();

  bool isEditing = true;
  bool isStudentListExpanded = false;
  List<User> allStudents = [];
  List<User> filteredStudents = [];
  Set<int> selectedStudentIds = Set<int>();

  @override
  void initState() {
    super.initState();
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

  Future<Group?> _fetchGroup(int groupId) async {
    String? token = await apiService.getJwtToken();
    if (token != null) {
      try {
        Group group = await apiService.getGroupById(token, groupId);
        return group;
      } catch (e) {
        print('Failed to fetch group: $e');
        return null;
      }
    }
    return null;
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

  Future<void> _updateStudentsWithGroupId(int groupId, String token) async {
    for (int studentId in selectedStudentIds) {
      User? student = allStudents.firstWhere((user) => user.id == studentId,);
      await apiService.updateUserWithoutPassword(
        id: student.id,
        login: student.login,
        name: student.name,
        surname: student.surname,
        patronymic: student.patronymic,
        phoneNumber: student.phoneNumber,
        avatarLink: student.avatarLink,
        role: student.role,
        groupId: groupId,
        token: token,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
                    text: "Номер группы",
                    style: figmaTextStyles.caption1Medium.copyWith(color: FigmaColors.darkBlueMain),
                    align: TextAlign.center,
                  ),
                ),
                CustomTextField(
                  hintText: '',
                  maxLines: 1,
                  controller: _numberController,
                  figmaTextStyles: figmaTextStyles,
                  enabled: isEditing,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: CustomText(
                    text: "Номер курса",
                    style: figmaTextStyles.caption1Medium.copyWith(color: FigmaColors.darkBlueMain),
                    align: TextAlign.center,
                  ),
                ),
                CustomTextField(
                  hintText: '',
                  maxLines: 1,
                  controller: _courseNubmerController,
                  figmaTextStyles: figmaTextStyles,
                  enabled: isEditing,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: CustomButton(
                    text: 'Создать группу',
                    onPressed: () async {
                      String? token = await apiService.getJwtToken();
                      if (token != null) {
                        try {
                          print(widget.groupId);
                          int groupNumber = int.parse(_numberController.text);
                          int courseNumber = int.parse(_courseNubmerController.text);

                          int? groupId = await apiService.updateGroup(
                            token: token,
                            groupNumber: groupNumber,
                            courseNumber: courseNumber,
                            id: widget.groupId,
                          );

                          if (groupId != null) {
                            await _updateStudentsWithGroupId(groupId, token);
                            AppRoutes.navigateToPageWithFadeTransition(context, GroupsPage(userId: widget.userId));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Группа обновлена и студенты обновлены'),
                              ),
                            );
                          }
                        } catch (e) {
                          print('Failed to create group or update students: $e');
                        }
                      }
                    },
                    figmaTextStyles: figmaTextStyles,
                  ),
                ),
                SizedBox(height: 36),
                ExpansionTile(
                  title: Text(
                    "Список студентов",
                    style: figmaTextStyles.caption1Medium.copyWith(color: FigmaColors.darkBlueMain),
                  ),
                  initiallyExpanded: isStudentListExpanded,
                  onExpansionChanged: (bool expanded) {
                    setState(() => isStudentListExpanded = expanded);
                  },
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: CustomText(
                        text: "Поиск студентов",
                        style: figmaTextStyles.caption1Medium.copyWith(color: FigmaColors.darkBlueMain),
                        align: TextAlign.center,
                      ),
                    ),
                    CustomTextField(
                      hintText: 'Введите имя, фамилию или отчество',
                      maxLines: 1,
                      controller: _searchController,
                      figmaTextStyles: figmaTextStyles,
                      enabled: true,
                    ),
                    SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: filteredStudents.length,
                      itemBuilder: (context, index) {
                        User student = filteredStudents[index];
                        return FutureBuilder<Group?>(
                          future: _fetchGroup(student.groupId ?? 0),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return ListTile(
                                title: Text('${student.name} ${student.surname} ${student.patronymic}'),
                                subtitle: Text('Загрузка...'),
                                trailing: Checkbox(
                                  value: selectedStudentIds.contains(student.id),
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value == true) {
                                        selectedStudentIds.add(student.id);
                                      } else {
                                        selectedStudentIds.remove(student.id);
                                      }
                                    });
                                  },
                                ),
                              );
                            } else if (snapshot.hasError || snapshot.data == null) {
                              return ListTile(
                                title: Text('${student.name} ${student.surname} ${student.patronymic}'),
                                subtitle: Text('Ошибка загрузки данных группы'),
                                trailing: Checkbox(
                                  value: selectedStudentIds.contains(student.id),
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value == true) {
                                        selectedStudentIds.add(student.id);
                                      } else {
                                        selectedStudentIds.remove(student.id);
                                      }
                                    });
                                  },
                                ),
                              );
                            } else {
                              Group group = snapshot.data!;
                              return ListTile(
                                title: Text('${student.name} ${student.surname} ${student.patronymic}'),
                                subtitle: Text('Группа: ${group.groupNumber}, Курс: ${group.courseNumber}'),
                                trailing: Checkbox(
                                  value: selectedStudentIds.contains(student.id),
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value == true) {
                                        selectedStudentIds.add(student.id);
                                      } else {
                                        selectedStudentIds.remove(student.id);
                                      }
                                    });
                                  },
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _numberController.dispose();
    _courseNubmerController.dispose();
    super.dispose();
  }
}
