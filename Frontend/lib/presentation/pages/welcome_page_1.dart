import 'package:project_pal/core/app_export.dart';

class WelcomePage1 extends StatelessWidget {
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(color: FigmaColors.whiteBackground),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  ImageConstant.mediumIcon,
                  width: 81,
                  height: 116,
                ),
                SizedBox(height: 20),
                Text(
                  'ProjectPal',
                  textAlign: TextAlign.center,
                  style: figmaTextStyles.header1Bold.copyWith(
                    color: FigmaColors.darkBlueMain,
                  ),
                ),
              ],
            ),
            SizedBox(height: 115),
            Image.asset(
              ImageConstant.welcomeInfo1,
              width: 333,
              height: 185,
            ),
            SizedBox(height: 56),
            Text(
              'Все ваши задания и проекты в одном приложении',
              textAlign: TextAlign.center,
              style: figmaTextStyles.header1Medium.copyWith(
                color: FigmaColors.darkBlueMain,
              ),
            ),
            SizedBox(height: 60),
            GestureDetector(
              onTap: () {
                AppRoutes.navigateToPageWithFadeTransition(context, WelcomePage2());
              },
              child: Container(
                width: 100,
                height: 100,
                child: Image.asset(
                  ImageConstant.buttonNext1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
