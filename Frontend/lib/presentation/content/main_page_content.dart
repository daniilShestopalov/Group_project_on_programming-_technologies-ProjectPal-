import 'dart:math';

import 'package:flutter/material.dart';
import 'package:project_pal/core/app_export.dart';

class MainPageContent extends StatefulWidget {
  final int userId;

  const MainPageContent({Key? key, required this.userId}) : super(key: key);

  @override
  _MainPageContentState createState() => _MainPageContentState();
}

class _MainPageContentState extends State<MainPageContent> {
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();

  // Допустим, у вас есть переменная для отслеживания выполненных задач
  int completedTasks = 1;
  int totalTasks = 3; // Просто для примера, замените это на реальное количество задач

  @override
  Widget build(BuildContext context) {
    // Рассчитаем процент выполнения задач
    double completionPercentage = completedTasks / totalTasks;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Ваш текущий контент
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Добрый день,\n' + DataUtils.getUserNameById(widget.userId),
                style: figmaTextStyles.header2Regular.copyWith(
                  color: FigmaColors.darkBlueMain,
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Center(
                      child: CustomText(
                        text: 'Ваша статистика',
                        style: figmaTextStyles.header1Medium.copyWith(
                          color: FigmaColors.darkBlueMain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
        // Добавим круг под текущим содержимым и выровняем его по центру
        Center(
          child: Container(
            width: 300, // Задаем ширину круга (можно настроить по вашему усмотрению)
            height: 300, // Задаем высоту круга
            child: CustomPaint(
              painter: CirclePainter(
                progress: completionPercentage,
                startColor: FigmaColors.darkBlueMain,
                endColor: FigmaColors.contrastToMain,
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Center(
                child: CustomText(
                  text: 'Всего заданий: 3',
                  style: figmaTextStyles.header2Medium.copyWith(
                    color: FigmaColors.darkBlueMain,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Center(
              child: CustomText(
              text: 'Выполнено заданий: 1',
              style: figmaTextStyles.header2Medium.copyWith(
              color: FigmaColors.darkBlueMain,
              ),
              ),
              ),
            ),
      ],
    );
  }
}

class CirclePainter extends CustomPainter {
  final double progress;
  final Color startColor;
  final Color endColor;

  CirclePainter({
    required this.progress,
    required this.startColor,
    required this.endColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = startColor
      ..style = PaintingStyle.fill;

    // Вычисляем центр и радиус круга
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);

    // Рисуем фоновый круг
    canvas.drawCircle(center, radius, paint);

    // Рассчитываем угол заливки в зависимости от прогресса выполнения
    double sweepAngle = 2 * pi * progress;

    // Рисуем заливку
    paint.color = endColor;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, // начальный угол
      sweepAngle, // угол заливки
      true,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
