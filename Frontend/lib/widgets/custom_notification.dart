import 'package:project_pal/core/app_export.dart';

class CustomNotification extends StatelessWidget {
  final List<NotificationItem> notifications;

  const CustomNotification({Key? key, required this.notifications}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double dialogHeight = 160.0 + notifications.length * 60.0;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      backgroundColor: FigmaColors.whiteBackground,
      child: Container(
        padding: EdgeInsets.all(16.0),
        constraints: BoxConstraints(
          maxHeight: dialogHeight,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Уведомления',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return NotificationCard(notification: notifications[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationItem {
  final String text;
  final String? avatarUrl;
  final bool isSystem;

  NotificationItem({
    required this.text,
    this.avatarUrl,
    this.isSystem = false,
  });
}

class NotificationCard extends StatelessWidget {
  final NotificationItem notification;

  const NotificationCard({Key? key, required this.notification}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FigmaTextStyles figmaTextStyles = FigmaTextStyles();
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Row(
          children: [
            if (!notification.isSystem)
              CircleAvatar(
                backgroundImage: NetworkImage(notification.avatarUrl ?? ''),
              ),
            if (!notification.isSystem)
              SizedBox(width: 10),
            Expanded(
              child: CustomText(
                text: notification.text,
                style: figmaTextStyles.header2Regular.copyWith(
                  color: FigmaColors.darkBlueMain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
