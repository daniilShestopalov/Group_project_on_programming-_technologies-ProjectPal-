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

  List<Group> groupBlocks = [];

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    try {
      final token = await apiService.getJwtToken(); // Получаем токен из хранилища
      final groups = await apiService.fetchGroups(token!);
      setState(() {
        groupBlocks = groups;
      });
    } catch (error) {
      print(error);
      // Обработка ошибки
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                  for (int index = 0; index < 2; index++)
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
                          index == 0 ? 'По количеству' : 'По номеру',
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
    );
  }

  void sortGroupsByGroupName() {
    setState(() {
      groupBlocks.sort((a, b) {
        return sortOrder == SortOrder.ascending ? a.groupNumber.compareTo(b.groupNumber) : b.groupNumber.compareTo(a.groupNumber);
      });
    });
  }

  void sortGroupsByNumberOfPeople() {
    setState(() {
      groupBlocks.sort((a, b) {
        return sortOrder == SortOrder.ascending ? a.courseNumber.compareTo(b.courseNumber) : b.courseNumber.compareTo(a.courseNumber);
      });
    });
  }

  void sortGroups(int index) {
    switch (index) {
      case 0:
        sortGroupsByNumberOfPeople();
        break;
      case 1:
        sortGroupsByGroupName();
        break;
      default:
        break;
    }
  }
}
