import 'package:project_pal/core/app_export.dart';

class StudentsPageContent extends StatefulWidget {
  final int userId;

  const StudentsPageContent({Key? key, required this.userId}) : super(key: key);

  @override
  _StudentsPageContentState createState() => _StudentsPageContentState();
}

class _StudentsPageContentState extends State<StudentsPageContent> {
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();
  final ApiService apiService = ApiService();

  List<User> students = []; // Список преподавателей

  @override
  void initState() {
    super.initState();
    loadProfessors(); // Вызываем метод загрузки преподавателей при инициализации
  }

  // Метод загрузки преподавателей
  Future<void> loadProfessors() async {

    final token = await apiService.getJwtToken();

    try {
      // Получаем список преподавателей из API
      final student = await ApiService().getUsersByRole('STUDENT', token!);
      setState(() {
        students = student;
      });
    } catch (e) {
      print('Error loading professors: $e');
    }
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
                        text: 'Учащиеся',
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
    );
  }
}
