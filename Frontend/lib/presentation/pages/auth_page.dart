import 'package:project_pal/core/app_export.dart';

class AuthPage extends StatefulWidget {
  @override
  State<AuthPage> createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                    controller: emailController,
                    figmaTextStyles: figmaTextStyles,
                  ),
                  SizedBox(height: 28),
                  CustomTextField(
                    hintText: 'Пароль',
                    obscureText: true,
                    controller: passwordController,
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
                      String email = emailController.text;
                      String password = passwordController.text;

                      // Проверяем логин и пароль
                      if (email.isNotEmpty && password.isNotEmpty) {
                        // Проверяем совпадение с моканными данными
                        bool validCredentials = DataUtils().validateCredentials(email, password);

                        if (validCredentials) {
                          // Отправка события успешного входа в приложение
                          AppMetrica.reportEvent('Вход успешно выполнен');

                          Map<String, dynamic>? user = MockData.usersData.firstWhere((user) => user['login'] == email && user['password'] == password, orElse: () => {});
                          int userId = user['id'];
                          AppRoutes.navigateToPageWithFadeTransition(context, MainPage(userId: userId,));
                        } else {
                          // Ошибка: неверный логин или пароль
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Ошибка'),
                              content: Text('Неверный логин или пароль'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                          );

                          // Отправка события неудачного входа в приложение
                          AppMetrica.reportEvent('Ошибка входа: неверный логин или пароль');
                        }
                      } else {
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

                        // Отправка события неудачного входа в приложение из-за пустых полей
                        AppMetrica.reportEvent('Ошибка входа: пустой логин или пароль');
                      }
                    },
                    figmaTextStyles: figmaTextStyles,
                  ),
                  SizedBox(height: 11),
                  CustomButton(
                    text: 'Регистрация',
                    onPressed: () {
                      AppMetrica.reportEvent('Переход на страницу регистрации');
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
