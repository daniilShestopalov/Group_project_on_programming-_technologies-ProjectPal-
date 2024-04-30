import './core/app_export.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting('ru').then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppMetrica.activate(AppMetricaConfig('18ca9986-9ada-44a9-9b66-379cffdccc9a'));
    return MaterialApp(
      title: 'ProjectPal',
      onGenerateRoute: AppRoutes.generateRoute,
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
    );
  }
}
