import 'package:project_pal/core/app_export.dart';

class GroupsViewPageContent extends StatefulWidget {
  final int userId;
  final String groupNumber;

  const GroupsViewPageContent({Key? key, required this.userId, required this.groupNumber}) : super(key: key);

  @override
  _GroupsViewPageContentState createState() => _GroupsViewPageContentState();
}

class _GroupsViewPageContentState extends State<GroupsViewPageContent> {
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();

  SortOrder sortOrder = SortOrder.ascending;
  int selectedIndex = 0;

  List<int> studentUserIds = [];

  @override
  void initState() {
    super.initState();

    studentUserIds = DataUtils.getUserIdsByGroupNumber(MockData.usersData, widget.groupNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Блок 1
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
                        text: 'Группа ' + widget.groupNumber,
                        style: figmaTextStyles.header1Medium.copyWith(
                          color: FigmaColors.darkBlueMain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
        // Блок 2
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              itemCount: studentUserIds.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: CustomGroupListViewBlock(
                    userId: studentUserIds[index],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
