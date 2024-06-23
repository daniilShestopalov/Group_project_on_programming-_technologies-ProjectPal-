import 'package:flutter/material.dart';
import 'package:project_pal/core/app_export.dart';

class ResetPasswordPage3 extends StatelessWidget {
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
                    CustomTextField(
                      hintText: 'Новый пароль',
                      obscureText: true,
                      figmaTextStyles: figmaTextStyles,
                    ),
                    SizedBox(height: 24),
                    CustomTextField(
                      hintText: 'Повторите пароль',
                      obscureText: true,
                      figmaTextStyles: figmaTextStyles,
                    ),
                    SizedBox(height: 180),
                    CustomButton(
                      text: 'Подтвердить пароль',
                      onPressed: () {
                        AppRoutes.navigateToPageWithFadeTransition(context, ResetPasswordPage4());
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