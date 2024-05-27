import 'package:project_pal/core/app_export.dart';

class RegistrationPage1 extends StatelessWidget {
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(color: FigmaColors.whiteBackground),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
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
                CustomTextField(
                  hintText: 'Логин',
                  controller: loginController,
                  figmaTextStyles: figmaTextStyles,
                ),
                SizedBox(height: 28),
                CustomTextField(
                  hintText: 'Пароль',
                  obscureText: true,
                  controller: passwordController,
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
                  onPressed: () async {
                    String login = loginController.text;
                    String password = passwordController.text;

                    if (login.isNotEmpty && password.isNotEmpty) {
                      try {
                        print("Attempting to verify temp user with $login and $password");
                        var user = await apiService.verifyTempUser(login, password);
                        print("Verification successful");


                        // Переход на следующую страницу регистрации
                        AppRoutes.navigateToPageWithFadeTransition(context, RegistrationPage2(user: user));
                                            } catch (e) {
                        print("Verification failed: $e");
                        // Обработка других ошибок верификации
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Ошибка'),
                            content: Text('Произошла ошибка при верификации'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    } else {
                      print("Empty login or password");
                      // Ошибка: пустой логин или пароль
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Ошибка'),
                          content: Text('Пожалуйста, введите логин и пароль'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  figmaTextStyles: figmaTextStyles,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
