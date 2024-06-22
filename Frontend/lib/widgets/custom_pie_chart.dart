import 'package:project_pal/core/app_export.dart';

class CustomPieChart extends StatefulWidget {
  final int allTasks;
  final int incompleteTasks;

  const CustomPieChart({
    Key? key,
    required this.allTasks,
    required this.incompleteTasks,
  }) : super(key: key);

  @override
  _CustomPieChartState createState() => _CustomPieChartState();
}

class _CustomPieChartState extends State<CustomPieChart> {
  int touchedIndex = -1;
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1.5,
          child: Center(
            child: AspectRatio(
              aspectRatio: 1.1,
              child: PieChart(
                PieChartData(
                  sections: _showingSections(),
                  borderData: FlBorderData(show: false),
                  centerSpaceRadius: 60,
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, PieTouchResponse? pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        GestureDetector(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Center(
              child: CustomText(
                text: 'Всего заданий: ${widget.allTasks}',
                style: figmaTextStyles.header2Medium.copyWith(
                  color: touchedIndex == 0 ? FigmaColors.selectorColor : FigmaColors.darkBlueMain,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Center(
              child: CustomText(
                text: 'Всего проектов: ${widget.incompleteTasks}',
                style: figmaTextStyles.header2Medium.copyWith(
                  color: touchedIndex == 1 ? FigmaColors.selectorColor : FigmaColors.darkBlueMain,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> _showingSections() {
    return [
      PieChartSectionData(
        color: FigmaColors.darkBlueMain,
        value: widget.allTasks.toDouble(),
        radius: touchedIndex == 0 ? 70.0 : 50.0,
        badgeWidget: _buildBadgeWidget(FigmaColors.darkBlueMain),
      ),
      PieChartSectionData(
        color: FigmaColors.lightRedMain,
        value: widget.incompleteTasks.toDouble(),
        radius: touchedIndex == 1 ? 70.0 : 50.0,
        badgeWidget: _buildBadgeWidget(FigmaColors.lightRedMain),
      ),
    ];
  }

  Widget _buildBadgeWidget(Color color) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
