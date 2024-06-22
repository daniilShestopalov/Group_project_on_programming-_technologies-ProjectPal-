import 'package:project_pal/core/app_export.dart';

class ProfessorPageContent extends StatefulWidget {
  final int userId;

  const ProfessorPageContent({Key? key, required this.userId}) : super(key: key);

  @override
  _ProfessorPageContentState createState() => _ProfessorPageContentState();
}

class _ProfessorPageContentState extends State<ProfessorPageContent> {
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();
  final ApiService apiService = ApiService();

  List<User> professors = []; // Список преподавателей

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
      final professor = await ApiService().getUsersByRole('TEACHER', token!);
      setState(() {
        professors = professor;
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
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              itemCount: professors.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: CustomGroupListViewBlock(
                    userId: widget.userId,
                    user: professors[index],

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
