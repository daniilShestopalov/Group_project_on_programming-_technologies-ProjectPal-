import '../../core/app_export.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  // Вызываем метод для перехода на экран приветствия после построения виджета
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 2), () {
        AppRoutes.navigateToPageWithFadeTransition(context, WelcomePage1());
      });
    });

    final FigmaTextStyles figmaTextStyles = FigmaTextStyles();

    return Scaffold(
      body: Center(
        child: Container(
          width: 360,
          height: 800,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: FigmaColors.whiteBackground),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 360,
                height: 106,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: FigmaColors.whiteBackground,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 360,
                      height: 106,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Opacity(
                            opacity: 0.12,
                            child: Container(
                              width: 360,
                              height: 106,
                              decoration: BoxDecoration(
                                  color: FigmaColors.whiteBackground),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 360,
                height: 64,
                decoration: BoxDecoration(color: FigmaColors.whiteBackground),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 233,
                    height: 334,
                    child: Image.asset(ImageConstant.largeIcon),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'ProjectPal',
                    textAlign: TextAlign.center,
                    style: figmaTextStyles.header0Bold.copyWith(
                      color: FigmaColors.darkBlueMain,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
