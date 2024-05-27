import 'package:project_pal/core/app_export.dart';

class ResetPasswordPage1 extends StatelessWidget {
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();
  final TextEditingController emailController = TextEditingController();
  final ApiService apiService = ApiService();

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
            Center(
              child: CustomText(
                text: 'Восстановление пароля',
                style: figmaTextStyles.header0Bold.copyWith(
                  color: FigmaColors.darkBlueMain,
                ),
                align: TextAlign.center,
              ),
            ),
            SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: CustomTextField(
                      hintText: 'email',
                      keyboardType: TextInputType.emailAddress,
                      figmaTextStyles: figmaTextStyles,
                      controller: emailController,
                    ),
                  ),
                  SizedBox(height: 24),
                  Center(
                    child: CustomText(
                      text: 'Введите Email, который использовался при регистрации',
                      style: figmaTextStyles.regularText.copyWith(
                        color: FigmaColors.darkBlueMain,
                      ),
                      align: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 180),
                  CustomButton(
                    text: 'Получить код',
                    onPressed: () async {
                      // Получаем введенный email из текстового поля
                      String email = emailController.text;
                      try {
                        await apiService.sendPasswordResetCode(email);
                        AppRoutes.navigateToPageWithFadeTransition(context, ResetPasswordPage2());
                      } catch (e) {
                        // Обработка ошибки, если не удалось отправить код
                        print('Ошибка: $e');
                        // Показать сообщение об ошибке пользователю
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Ошибка'),
                              content: Text('Не удалось отправить код. Пожалуйста, проверьте ваш email и попробуйте еще раз.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
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