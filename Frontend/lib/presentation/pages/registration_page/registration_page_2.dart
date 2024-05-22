import 'package:project_pal/core/app_export.dart';

class RegistrationPage2 extends StatelessWidget {

  final int id;
  final String name;
  final String surname;
  final String patronymic;

  RegistrationPage2({required this.name, required this.surname, required this.patronymic, required this.id});

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
                      hintText: surname,
                      enabled: false,
                      figmaTextStyles: figmaTextStyles,
                    ),
                    SizedBox(height: 17),
                    CustomTextField(
                      hintText: name,
                      enabled: false,
                      figmaTextStyles: figmaTextStyles,
                    ),
                    SizedBox(height: 17),
                    CustomTextField(
                      hintText: patronymic,
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
                      figmaTextStyles: figmaTextStyles,
                    ),
                    SizedBox(height: 17),
                    CustomTextField(
                      hintText: 'Повторите пароль',
                      obscureText: true,
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
                          try {
                            apiService.registerUser(id, login, phoneNumber, password);
                            print("registration successful");
                            AppRoutes.navigateToPageWithFadeTransition(context, RegistrationPage3());
                          } catch (e) {
                            print("Verification failed: $e");
                            // Обработка ошибки верификации
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
                          }
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
}
