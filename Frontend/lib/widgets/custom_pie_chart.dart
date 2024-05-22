import 'package:project_pal/core/app_export.dart';

class CustomPieChart extends StatefulWidget {
  final int completedTasks;
  final int incompleteTasks;

  const CustomPieChart({
    Key? key,
    required this.completedTasks,
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
        GestureDetector(
          onTap: () {
            setState(() {
              touchedIndex = 0;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Center(
              child: CustomText(
                text: 'Выполненные задания: ${widget.completedTasks}',
                style: figmaTextStyles.header2Medium.copyWith(
                  color: touchedIndex == 0 ? FigmaColors.selectorColor : FigmaColors.darkBlueMain,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              touchedIndex = 1;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Center(
              child: CustomText(
                text: 'Невыполненные задания: ${widget.incompleteTasks}',
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
        value: widget.completedTasks.toDouble(),
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
