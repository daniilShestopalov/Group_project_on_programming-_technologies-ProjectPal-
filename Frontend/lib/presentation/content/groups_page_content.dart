import 'package:project_pal/core/app_export.dart';

class GroupsPageContent extends StatefulWidget {
  final int userId;

  const GroupsPageContent({Key? key, required this.userId}) : super(key: key);

  @override
  _GroupsPageContentState createState() => _GroupsPageContentState();
}

class _GroupsPageContentState extends State<GroupsPageContent> {
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();
  final ApiService apiService = ApiService();

  SortOrder sortOrder = SortOrder.ascending;
  int selectedIndex = 0;
  User? user;

  List<Group> groupBlocks = [];

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    try {
      final token = await apiService.getJwtToken();

      if (token == null) {
        throw Exception('Token is null');
      }

      final userLoaded = await apiService.getUserById(token, widget.userId);

      final groups = await apiService.fetchGroups(token);

      for (var group in groups) {
        final countOfPeople = await apiService.getUserCountByGroup(group.id, token); // Передача id группы
        group.countOfPeople = countOfPeople;
      }

      setState(() {
        groupBlocks = groups;
        user = userLoaded;
      });
    } catch (error) {
      print('Error during loading groups: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: user?.role != 'STUDENT'
          ? FloatingActionButton(
        onPressed: () {
          AppRoutes.navigateToPageWithFadeTransition(
              context,
              GroupCreatePage(userId: widget.userId,));
        },
        child: Icon(Icons.create_outlined),
        backgroundColor: FigmaColors.contrastToMain,
      )
          : null,
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
                          text: 'Группы',
                          style: figmaTextStyles.header1Medium.copyWith(
                            color: FigmaColors.darkBlueMain,
                          ),
                        ),
                      ),
                    ),
                    SortIcon(
                      initialOrder: sortOrder,
                      onSortChanged: (order) {
                        setState(() {
                          sortOrder = order;
                          sortGroups(selectedIndex);
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (int index = 0; index < 3; index++)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                            sortGroups(index);
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: index == selectedIndex ? FigmaColors.darkBlueMain : Colors.transparent,
                                width: 2.0,
                              ),
                            ),
                          ),
                          child: Text(
                            index == 0 ? 'По номеру' : index == 1 ? 'По количеству' : 'По курсу',
                            style: figmaTextStyles.caption1Regular.copyWith(
                              color: index == selectedIndex ? FigmaColors.darkBlueMain : FigmaColors.exitColor,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: ListView.builder(
                itemCount: groupBlocks.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: CustomGroupListBlock(
                      userId: widget.userId,
                      group: groupBlocks[index],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }


  void sortGroupsByNumberOfGroup() {
    setState(() {
      groupBlocks.sort((a, b) {
        return sortOrder == SortOrder.ascending ? a.groupNumber.compareTo(b.groupNumber) : b.groupNumber.compareTo(a.groupNumber);
      });
    });
  }

  void sortGroupsByNumberOfPeople() {
    setState(() {
      groupBlocks.sort((a, b) {
        return sortOrder == SortOrder.ascending ? a.countOfPeople.compareTo(b.countOfPeople) : b.countOfPeople.compareTo(a.countOfPeople);
      });
    });
  }

  void sortGroupsByNumberOfCourse() {
    setState(() {
      groupBlocks.sort((a, b) {
        return sortOrder == SortOrder.ascending ? a.courseNumber.compareTo(b.courseNumber) : b.courseNumber.compareTo(a.courseNumber);
      });
    });
  }


  void sortGroups(int index) {
    switch (index) {
      case 0:
        sortGroupsByNumberOfGroup();
        break;
      case 1:
        sortGroupsByNumberOfPeople();
        break;
      case 2:
        sortGroupsByNumberOfCourse();
        break;
      default:
        break;
    }
  }
}
