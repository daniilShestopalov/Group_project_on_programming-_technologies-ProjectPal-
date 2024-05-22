import 'package:flutter/material.dart';
import 'package:project_pal/core/app_export.dart';

class RegistrationPage2 extends StatelessWidget {
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
                      hintText: 'Третьяков',
                      enabled: false,
                      figmaTextStyles: figmaTextStyles,
                    ),
                    SizedBox(height: 17),
                    CustomTextField(
                      hintText: 'Данила',
                      enabled: false,
                      figmaTextStyles: figmaTextStyles,
                    ),
                    SizedBox(height: 17),
                    CustomTextField(
                      hintText: 'Сергеевич',
                      enabled: false,
                      figmaTextStyles: figmaTextStyles,
                    ),
                    SizedBox(height: 17),
                    CustomTextField(
                      hintText: 'Логин',
                      keyboardType: TextInputType.text,
                      figmaTextStyles: figmaTextStyles,
                    ),
                    SizedBox(height: 17),
                    CustomTextField(
                      hintText: 'email',
                      keyboardType: TextInputType.emailAddress,
                      figmaTextStyles: figmaTextStyles,
                    ),
                    SizedBox(height: 17),
                    CustomTextField(
                      hintText: 'Пароль',
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
                      onPressed: () {
                        AppRoutes.navigateToPageWithFadeTransition(context, RegistrationPage3());
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
