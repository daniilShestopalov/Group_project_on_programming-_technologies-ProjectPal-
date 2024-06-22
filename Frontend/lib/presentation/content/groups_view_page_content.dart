import 'package:flutter/material.dart';
import 'package:project_pal/core/app_export.dart';

class GroupsViewPageContent extends StatefulWidget {
  final int userId;
  final Group group;

  const GroupsViewPageContent({
    Key? key,
    required this.userId,
    required this.group,
  }) : super(key: key);

  @override
  _GroupsViewPageContentState createState() => _GroupsViewPageContentState();
}

class _GroupsViewPageContentState extends State<GroupsViewPageContent> {
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();
  final ApiService apiService = ApiService();

  SortOrder sortOrder = SortOrder.ascending;
  List<User> students = [];
  User? user;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    try {
      final token = await apiService.getJwtToken();
      final _user = await apiService.getUserById(token!, widget.userId);
      final loadedStudents = await apiService.getUsersByGroup(widget.group.id, token!);

      setState(() {
        students = loadedStudents;
        user = _user;
      });
    } catch (error) {
      print('Error loading students: $error');
    }
  }

  void _sortStudentsByFullName() {
    setState(() {
      if (sortOrder == SortOrder.ascending) {
        students.sort((a, b) => a.surname.compareTo(b.surname));
        sortOrder = SortOrder.descending;
      } else {
        students.sort((a, b) => b.surname.compareTo(a.surname));
        sortOrder = SortOrder.ascending;
      }
    });
  }

  Future<void> _deleteGroup() async {
    try {
      final token = await apiService.getJwtToken();
      await apiService.deleteGroup(token: token!, groupId: widget.group.id);
      AppRoutes.navigateToPageWithFadeTransition(
        context,
        GroupsPage(userId: widget.userId),
      );
    } catch (error) {
      print('Error deleting group: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isAdmin = user?.role != 'STUDENT';

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: CustomText(
                          text: 'Группа ${widget.group.groupNumber}',
                          style: figmaTextStyles.header1Medium.copyWith(
                            color: FigmaColors.darkBlueMain,
                          ),
                          align: TextAlign.center,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.sort_by_alpha),
                      onPressed: _sortStudentsByFullName,
                    ),
                  ],
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: CustomGroupListViewBlock(
                      userId: widget.userId,
                      user: students[index],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: isAdmin
          ? Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => _deleteGroup(),
            child: Icon(Icons.delete),
            backgroundColor: Colors.red,
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              AppRoutes.navigateToPageWithFadeTransition(
                context,
                GroupUpdatePage(
                  userId: widget.userId,
                  groupId: widget.group.id,
                ),
              );
            },
            child: Icon(Icons.create_outlined),
            backgroundColor: FigmaColors.contrastToMain,
          ),
        ],
      )
          : null, // If not admin, no floating action buttons
    );
  }
}
