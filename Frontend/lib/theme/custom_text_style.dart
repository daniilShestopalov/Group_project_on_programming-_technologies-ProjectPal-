import 'package:project_pal/core/app_export.dart';

class FigmaColors {
  const FigmaColors();

  static const Color lightBlueBackground = Color(0xff89c7ea);
  static const Color whiteBackground = Color(0xfff7faf8);
  static const Color darkBlueMain = Color(0xff20395c);
  static const Color lightRedMain = Color(0xFFC55353);
  static const Color greenGrade = Color(0xFF85C8A0);
  static const Color contrastToMain = Color(0xff009caf);
  static const Color exitColor = Color(0xff82bdcc);
  static const Color selectorColor = Color(0xff0078d2);
  static const Color whiteText = Color(0xffffffff);
  static const Color red = Color(0xffd00f0f);
  static const Color exitDayColor = Color(0xff98BDC9);
  static const Color workDayColor = Color(0xffC6D8DE);
  static const Color editTask = Color(0xffFCEBC1);
}

class FigmaTextStyles {
  const FigmaTextStyles();

  TextStyle get header0Bold => const TextStyle(
    fontSize: 40,
    decoration: TextDecoration.none,
    fontFamily: 'Roboto-Bold',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 40 / 40,
    letterSpacing: 0,
  );

  TextStyle get header1Medium => const TextStyle(
    fontSize: 24,
    decoration: TextDecoration.none,
    fontFamily: 'Roboto-Medium',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    height: 28 / 24,
    letterSpacing: 0,
  );

  TextStyle get header1Bold => const TextStyle(
    fontSize: 24,
    decoration: TextDecoration.none,
    fontFamily: 'Roboto-Bold',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 28 / 24,
    letterSpacing: 0,
  );

  TextStyle get header2Regular => const TextStyle(
    fontSize: 20,
    decoration: TextDecoration.none,
    fontFamily: 'Roboto-Regular',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 24 / 20,
    letterSpacing: 0,
  );

  TextStyle get header2Bold => const TextStyle(
    fontSize: 20,
    decoration: TextDecoration.none,
    fontFamily: 'Roboto-Bold',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 24 / 20,
    letterSpacing: 0.37,
  );

  TextStyle get headerTextRegular => const TextStyle(
    fontSize: 16,
    decoration: TextDecoration.none,
    fontFamily: 'Roboto-Regular',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 20 / 16,
    letterSpacing: 0.1,
  );

  TextStyle get header2Medium => const TextStyle(
    fontSize: 20,
    decoration: TextDecoration.none,
    fontFamily: 'Roboto-Medium',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    height: 24 / 20,
    letterSpacing: 0,
  );

  TextStyle get headerTextMedium => const TextStyle(
    fontSize: 16,
    decoration: TextDecoration.none,
    fontFamily: 'Roboto-Medium',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    height: 20 / 16,
    letterSpacing: 0.1,
  );

  TextStyle get regularText => const TextStyle(
    fontSize: 15,
    decoration: TextDecoration.none,
    fontFamily: 'Roboto-Regular',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 20 / 15,
    letterSpacing: 0.2,
  );

  TextStyle get mediumText => const TextStyle(
    fontSize: 15,
    decoration: TextDecoration.none,
    fontFamily: 'Roboto-Medium',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
    height: 20 / 15,
    letterSpacing: 0.2,
  );

  TextStyle get subHeaderRegular => const TextStyle(
    fontSize: 14,
    decoration: TextDecoration.none,
    fontFamily: 'Roboto-Regular',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 18 / 14,
    letterSpacing: 0.2,
  );

  TextStyle get subHeaderMedium => const TextStyle(
    fontSize: 14,
    decoration: TextDecoration.none,
    fontFamily: 'Roboto-Medium',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    height: 18 / 14,
    letterSpacing: 0.2,
  );

  TextStyle get subHeaderBold => const TextStyle(
    fontSize: 14,
    decoration: TextDecoration.none,
    fontFamily: 'Roboto-Medium',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    height: 18 / 14,
    letterSpacing: 0.2,
  );

  TextStyle get caption1Regular => const TextStyle(
    fontSize: 13,
    decoration: TextDecoration.none,
    fontFamily: 'Roboto-Regular',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 16 / 13,
    letterSpacing: 0.2,
  );

  TextStyle get caption1Medium => const TextStyle(
    fontSize: 13,
    decoration: TextDecoration.none,
    fontFamily: 'Roboto-Medium',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    height: 16 / 13,
    letterSpacing: 0.2,
  );

  TextStyle get captionCaps1Medium => const TextStyle(
    fontSize: 13,
    decoration: TextDecoration.none,
    fontFamily: 'Roboto-Medium',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    height: 16 / 13,
    letterSpacing: 0.2,
  );

  TextStyle get caption2Regular => const TextStyle(
    fontSize: 12,
    decoration: TextDecoration.none,
    fontFamily: 'Roboto-Regular',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 14 / 12,
    letterSpacing: 0.2,
  );

  TextStyle get caption2Medium => const TextStyle(
    fontSize: 12,
    decoration: TextDecoration.none,
    fontFamily: 'Roboto-Medium',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    height: 14 / 12,
    letterSpacing: 0.2,
  );

  TextStyle get captionCaps2Medium => const TextStyle(
    fontSize: 12,
    decoration: TextDecoration.none,
    fontFamily: 'Roboto-Medium',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    height: 14 / 12,
    letterSpacing: 0.3,
  );

  TextStyle get caption3Regular => const TextStyle(
    fontSize: 11,
    decoration: TextDecoration.none,
    fontFamily: 'Roboto-Regular',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 14 / 11,
    letterSpacing: 0.3,
  );

  TextStyle get caption3CapsMedium => const TextStyle(
    fontSize: 11,
    decoration: TextDecoration.none,
    fontFamily: 'Roboto-Medium',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    height: 14 / 11,
    letterSpacing: 0.3,
  );

  TextStyle get caption4Regular => const TextStyle(
    fontSize: 9,
    decoration: TextDecoration.none,
    fontFamily: 'Roboto-Regular',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 12 / 9,
    letterSpacing: 0.3,
  );

  TextStyle get captionCaps4Bold => const TextStyle(
    fontSize: 9,
    decoration: TextDecoration.none,
    fontFamily: 'Roboto-Bold',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 12 / 9,
    letterSpacing: 0.3,
  );
}
