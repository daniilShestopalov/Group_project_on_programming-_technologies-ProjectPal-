import 'package:project_pal/core/app_export.dart';

class ResetPasswordPage4 extends StatelessWidget {
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
                CustomText(
                  text: 'ProjectPal',
                  style: figmaTextStyles.header1Bold.copyWith(
                    color: FigmaColors.darkBlueMain,
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
            CustomText(
              text: 'Восстановление пароля',
              style: figmaTextStyles.header0Bold.copyWith(
                color: FigmaColors.darkBlueMain,
              ),
              align: TextAlign.center,
            ),
            SizedBox(height: 65),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: CustomText(
                      text: 'Учетная запись успешно зарегистрирована',
                      style: figmaTextStyles.header1Medium.copyWith(
                        color: FigmaColors.darkBlueMain,
                      ),
                      align: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 270),
                  CustomButton(
                    text: 'Вернуться',
                    onPressed: () {
                      AppRoutes.navigateToPageWithFadeTransition(context, AuthPage());
                    },
                    figmaTextStyles: figmaTextStyles,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
