import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './core/app_export.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Устанавливаем стиль для статус-бара глобально
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // делает статус-бар прозрачным
    statusBarIconBrightness: Brightness.dark, // устанавливает цвет иконок в статус-баре на темный (черный)
    statusBarBrightness: Brightness.dark, // для iOS
  ));

  // Инициализация хранения данных
  final prefs = await SharedPreferences.getInstance();
  bool isFirstRun = prefs.getBool('isFirstRun') ?? true;

  // Если первый запуск, устанавливаем значение в false
  if (isFirstRun) {
    await prefs.setBool('isFirstRun', false);
  }

  initializeDateFormatting('ru').then((_) {
    runApp(MyApp(isFirstRun: isFirstRun));
  });
}

class MyApp extends StatelessWidget {
  final bool isFirstRun;

  MyApp({required this.isFirstRun});

  @override
  Widget build(BuildContext context) {
    AppMetrica.activate(AppMetricaConfig('18ca9986-9ada-44a9-9b66-379cffdccc9a'));
    return MaterialApp(
      title: 'ProjectPal',
      onGenerateRoute: AppRoutes.generateRoute,
      initialRoute: isFirstRun ? '/' : '/auth',
      debugShowCheckedModeBanner: false,
    );
  }
}
