import 'package:flutter/material.dart';
import 'package:project_pal/core/app_export.dart';

class CustomComplaintListViewBlock extends StatefulWidget {
  final int userId;
  final Complaint complaint;

  const CustomComplaintListViewBlock({
    Key? key,
    required this.userId,
    required this.complaint,
  }) : super(key: key);

  @override
  _CustomComplaintListViewBlockState createState() =>
      _CustomComplaintListViewBlockState();
}

class _CustomComplaintListViewBlockState
    extends State<CustomComplaintListViewBlock> {
  Future<List<User>>? _userDataFuture;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final token = await apiService.getJwtToken();
      // Load user data for sender and complained about user
      final senderFuture =
      apiService.getUserById(token!, widget.complaint.complaintSenderUserId);
      final complainedAboutFuture = apiService.getUserById(
          token, widget.complaint.complainedAboutUserId);

      // Wait for both futures to complete
      setState(() {
        _userDataFuture = Future.wait([senderFuture, complainedAboutFuture]);
      });
    } catch (e) {
      setState(() {
        // Handle error by setting _userDataFuture to error state
        _userDataFuture = Future.error('Failed to load user data: $e');
      });
    }
  }

  Future<void> _deleteComplaint() async {
    try {
      final token = await apiService.getJwtToken();
      // Delete complaint
      await apiService.deleteComplaint(
        token: token!,
        complaintId: widget.complaint.id,
      );
      AppRoutes.navigateToPageWithFadeTransition(
        context,
        ComplaintPage(userId: widget.userId),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Жалоба удалена'),
        ),
      );
    } catch (e) {
      // Show SnackBar with error message if deletion fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Не удалось удалить жалобу: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<User>>(
      future: _userDataFuture,
      builder: (context, AsyncSnapshot<List<User>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Ошибка: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.length != 2) {
          return Center(child: Text('Данные недоступны'));
        }

        User sender = snapshot.data![0];
        User complainedAbout = snapshot.data![1];

        return GestureDetector(
          onTap: () {
            // Navigate to profile view page of complained about user
            AppRoutes.navigateToPageWithFadeTransition(
              context,
              ProfileViewPage(
                userId: widget.userId,
                userViewId: widget.complaint.complainedAboutUserId,
              ),
            );
          },
          child: IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFC6D8DE),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Жалоба № ${widget.complaint.id}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: FigmaColors.darkBlueMain,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Отправил жалобу: ${sender.name} ${sender.surname} ${sender.patronymic}',
                          style: TextStyle(
                            fontSize: 16,
                            color: FigmaColors.darkBlueMain,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Жалоба на: ${complainedAbout.name} ${complainedAbout.surname} ${complainedAbout.patronymic}',
                          style: TextStyle(
                            fontSize: 16,
                            color: FigmaColors.darkBlueMain,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: _deleteComplaint,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
