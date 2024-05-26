import 'package:project_pal/core/app_export.dart';

class ComplaintPageContent extends StatefulWidget {
  final int userId;

  const ComplaintPageContent({Key? key, required this.userId}) : super(key: key);

  @override
  _ComplaintPageContentState createState() => _ComplaintPageContentState();
}

class _ComplaintPageContentState extends State<ComplaintPageContent> {
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();

  List<int> professors = DataUtils.getTeacherIds();


  @override
  void initState() {
    super.initState();
    // Получаем список идентификаторов преподавателей и выводим его в консоль
    professors = DataUtils.getTeacherIds();
    print('List of professors: $professors');
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
                        text: 'Преподаватели',
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
        /*Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              itemCount: professors.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: CustomGroupListViewBlock(
                    userId: professors[index],
                  ),
                );
              },
            ),
          ),
        ),*/
      ],
    );
  }
}
