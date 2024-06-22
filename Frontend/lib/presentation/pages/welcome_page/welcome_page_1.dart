import 'package:project_pal/core/app_export.dart';

class WelcomePage1 extends StatelessWidget {
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();

  @override
  Widget build(BuildContext context) {
    // Получаем размер экрана
    final Size screenSize = MediaQuery.of(context).size;

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
            Padding(
              padding: EdgeInsets.only(top: screenSize.height * 0.055),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    ImageConstant.mediumIcon,
                    width: 81,
                    height: 116,
                  ),
                  SizedBox(height: screenSize.height * 0.014),
                  Text(
                    'ProjectPal',
                    textAlign: TextAlign.center,
                    style: figmaTextStyles.header1Bold.copyWith(
                      color: FigmaColors.darkBlueMain,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: screenSize.height * 0.1),
              child: Image.asset(
                ImageConstant.welcomeInfo1,
                width: 333,
                height: 185,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: screenSize.height * 0.072),
              child: Text(
                'Все ваши задания и проекты в одном приложении',
                textAlign: TextAlign.center,
                style: figmaTextStyles.header1Medium.copyWith(
                  color: FigmaColors.darkBlueMain,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: screenSize.height * 0.1),
              child: GestureDetector(
                onTap: () {
                  AppMetrica.reportEvent('Просмотр приветственных страниц');
                  AppRoutes.navigateToPageWithFadeTransition(context, WelcomePage2());
                },
                child: Container(
                  width: screenSize.width * 0.254,
                  height: screenSize.width * 0.254,
                  child: Image.asset(
                    ImageConstant.buttonNext1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
