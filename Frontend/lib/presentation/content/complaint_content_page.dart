import 'package:project_pal/core/app_export.dart';

class ComplaintPageContent extends StatefulWidget {
  final int userId;

  const ComplaintPageContent({Key? key, required this.userId}) : super(key: key);

  @override
  _ComplaintPageContentState createState() => _ComplaintPageContentState();
}

class _ComplaintPageContentState extends State<ComplaintPageContent> {
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();
  final ApiService apiService = ApiService();

  List<Complaint> complaint = []; // Список преподавателей

  @override
  void initState() {
    super.initState();
    loadComplaint();
  }

  Future<void> loadComplaint() async {

    final token = await apiService.getJwtToken();

    try {
      // Получаем список преподавателей из API
      final complaints = await ApiService().getComplaint(token!);
      setState(() {
        complaint = complaints;
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
                        text: 'Жалобы',
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
              itemCount: complaint.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: CustomComplaintListViewBlock(
                    userId: widget.userId,
                    complaint: complaint[index],
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
