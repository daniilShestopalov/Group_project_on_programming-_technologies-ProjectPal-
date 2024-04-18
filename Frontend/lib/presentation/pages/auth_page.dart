import 'package:project_pal/core/app_export.dart';

class AuthPage extends StatelessWidget {
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
              text: 'Вход',
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
                    hintText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    figmaTextStyles: figmaTextStyles,
                  ),
                  SizedBox(height: 28),
                  CustomTextField(
                    hintText: 'Пароль',
                    obscureText: true,
                    figmaTextStyles: figmaTextStyles,
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      CustomCheckbox(
                        value: false,
                        onChanged: (value) {},
                        label: 'Запомнить пароль',
                        figmaTextStyles: figmaTextStyles,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {},
                    child: UnderlineText(
                      text: 'Забыл пароль',
                      textStyle: TextStyle(
                        color: FigmaColors.darkBlueMain,
                        fontSize: 16,
                      ),
                      onTap: () {
                        AppRoutes.navigateToPageWithFadeTransition(context, ResetPasswordPage1());
                      },
                    ),
                  ),
                  SizedBox(height: 43),
                  CustomButton(
                    text: 'Войти',
                    onPressed: () {
                      AppRoutes.navigateToPageWithFadeTransition(context, MainPage());
                    },
                    figmaTextStyles: figmaTextStyles,
                  ),
                  SizedBox(height: 11),
                  CustomButton(
                    text: 'Регистрация',
                    onPressed: () {
                      AppRoutes.navigateToPageWithFadeTransition(context, RegistrationPage1());
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
