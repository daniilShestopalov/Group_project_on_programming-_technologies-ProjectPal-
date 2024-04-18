import 'package:project_pal/core/app_export.dart';

class RegistrationPage1 extends StatelessWidget {
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
              text: 'Регистрация',
              style: figmaTextStyles.header0Bold.copyWith(
                color: FigmaColors.darkBlueMain,
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomTextField(
                    hintText: 'Логин',
                    figmaTextStyles: figmaTextStyles,
                  ),
                  SizedBox(height: 28),
                  CustomTextField(
                    hintText: 'Пароль',
                    obscureText: true,
                    figmaTextStyles: figmaTextStyles,
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: CustomText(
                      text: 'Введите данные, выданные вам учебным заведением',
                      style: figmaTextStyles.regularText.copyWith(
                        color: FigmaColors.darkBlueMain,
                      ),
                      align: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 94),
                  CustomButton(
                    text: 'Продолжить',
                    onPressed: () {
                      AppRoutes.navigateToPageWithFadeTransition(context, RegistrationPage2());
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
