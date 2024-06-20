import 'package:project_pal/core/app_export.dart';

class RegistrationPage2 extends StatelessWidget {

  final User user;

  RegistrationPage2({required this.user});

  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final ApiService apiService = ApiService();
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
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
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomTextField(
                      hintText: '${user.name}',
                      enabled: false,
                      figmaTextStyles: figmaTextStyles,
                    ),
                    SizedBox(height: 17),
                    CustomTextField(
                      hintText: '${user.surname}',
                      enabled: false,
                      figmaTextStyles: figmaTextStyles,
                    ),
                    SizedBox(height: 17),
                    CustomTextField(
                      hintText: '${user.patronymic}',
                      enabled: false,
                      figmaTextStyles: figmaTextStyles,
                    ),
                    SizedBox(height: 17),

                    CustomTextField(
                      hintText: 'Email',
                      controller: loginController,
                      keyboardType: TextInputType.emailAddress,
                      figmaTextStyles: figmaTextStyles,
                    ),
                    SizedBox(height: 17),
                    CustomTextField(
                      hintText: 'Номер телефона',
                      controller: phoneNumberController,
                      keyboardType: TextInputType.text,
                      figmaTextStyles: figmaTextStyles,
                    ),
                    SizedBox(height: 17),
                    CustomTextField(
                      hintText: 'Пароль',
                      controller: passwordController,
                      obscureText: true,
                      maxLines: 1,
                      figmaTextStyles: figmaTextStyles,
                    ),
                    SizedBox(height: 17),
                    CustomTextField(
                      hintText: 'Повторите пароль',
                      obscureText: true,
                      maxLines: 1,
                      figmaTextStyles: figmaTextStyles,
                    ),
                    SizedBox(height: 20),
                    CustomButton(
                      text: 'Зарегистрироваться',
                      onPressed: () async {
                        String login = loginController.text;
                        String phoneNumber = phoneNumberController.text;
                        String password = passwordController.text;

                        if (login.isNotEmpty && phoneNumber.isNotEmpty && password.isNotEmpty) {
                          if (!isValidEmail(login)) {
                            // Показать диалоговое окно с ошибкой валидации
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Ошибка'),
                                content: Text('Пожалуйста, введите корректный адрес электронной почты'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('OK'),
                                  ),
                                ],
                              ),
                            );
                            return; // Прекратить выполнение метода если email некорректный
                          }

                          try {
                            await apiService.registerUser(user.id, login, phoneNumber, password);
                            print("registration successful");

                            // Переход на следующую страницу после успешной регистрации
                            AppRoutes.navigateToPageWithFadeTransition(context, RegistrationPage3());
                          } catch (e) {
                            print("Registration failed: $e");
                            // Обработка ошибки регистрации
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Ошибка'),
                                content: Text('Ошибка при регистрации пользователя'),
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
                          print("Empty login, phone number or password");
                          // Ошибка: пустое поле логина, номера телефона или пароля
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Ошибка'),
                              content: Text('Пожалуйста, заполните все поля'),
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
            ],
          ),
        ),
      ),
    );
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

}
