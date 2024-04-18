import 'package:flutter/material.dart';
import './routes/app_routes.dart';
import './core/app_export.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title',
      onGenerateRoute: AppRoutes.generateRoute,
      initialRoute: '/', // Начальный маршрут
    );
  }
}
