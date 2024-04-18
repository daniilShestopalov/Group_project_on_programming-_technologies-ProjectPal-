import 'package:flutter/material.dart';
import 'package:project_pal/core/app_export.dart';

class MainPageContent extends StatefulWidget {
  @override
  _MainPageContentState createState() => _MainPageContentState();
}

class _MainPageContentState extends State<MainPageContent> {
  final FigmaTextStyles figmaTextStyles = FigmaTextStyles();

  SortOrder sortOrder = SortOrder.ascending;
  int selectedIndex = 0;

  List<TaskBlockWidget> taskBlocks = [
    TaskBlockWidget(
      subject: 'Алгебра',
      date: '21.09',
      teacher: 'Маэстро',
      tasks: [
        Task(description: 'Описание задачи 1', isCompleted: true),
        Task(description: 'Описание задачи 2', isCompleted: false),
        Task(description: 'Описание задачи 3', isCompleted: false),
      ],
    ),
    TaskBlockWidget(
      subject: 'Геометрия',
      date: '22.09',
      teacher: 'Обэмэ',
      tasks: [
        Task(description: 'Описание задачи 1', isCompleted: true),
        Task(description: 'Описание задачи 2', isCompleted: true),
      ],
    ),
    TaskBlockWidget(
      subject: 'Русский Язык',
      date: '01.10',
      teacher: 'Абоба',
      tasks: [
        Task(description: 'Описание задачи 1', isCompleted: true),
        Task(description: 'Описание задачи 2', isCompleted: true),
        Task(description: 'Описание задачи 3', isCompleted: true),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Блок 1
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Добрый день,\nДанила',
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
                        text: 'Задания на сегодня',
                        style: figmaTextStyles.header1Medium.copyWith(
                          color: FigmaColors.darkBlueMain,
                        ),
                      ),
                    ),
                  ),
                  SortIcon(
                    initialOrder: sortOrder,
                    onSortChanged: (order) {
                      setState(() {
                        sortOrder = order;
                        sortTasksByDeadline();
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (int index = 0; index < 3; index++)
                    UnderlineText(
                      text: index == 0
                          ? 'По дедлайну'
                          : index == 1
                          ? 'По преподавателю'
                          : 'По предмету',
                      textStyle: figmaTextStyles.caption1Regular.copyWith(
                        color: index == selectedIndex
                            ? FigmaColors.darkBlueMain
                            : FigmaColors.exitColor,
                      ),
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                          sortTasksBy(index);
                        });
                      },
                    ),
                ],
              ),
            ],
          ),
        ),
        // Блок 2
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              itemCount: taskBlocks.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: TaskBlockWidget(
                    subject: taskBlocks[index].subject,
                    date: taskBlocks[index].date,
                    teacher: taskBlocks[index].teacher,
                    tasks: taskBlocks[index].tasks,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void sortTasksByDeadline() {
    setState(() {
      taskBlocks.sort((a, b) {
        List<String> partsA = a.date.split('.');
        List<String> partsB = b.date.split('.');

        int dayA = int.parse(partsA[0]);
        int monthA = int.parse(partsA[1]);
        int dayB = int.parse(partsB[0]);
        int monthB = int.parse(partsB[1]);

        if (sortOrder == SortOrder.ascending) {
          if (monthA != monthB) {
            return monthA.compareTo(monthB);
          } else {
            return dayA.compareTo(dayB);
          }
        } else {
          if (monthA != monthB) {
            return monthB.compareTo(monthA);
          } else {
            return dayB.compareTo(dayA);
          }
        }
      });
    });
  }

  void sortTasksByTeacher() {
    setState(() {
      taskBlocks.sort((a, b) {
        return a.teacher.compareTo(b.teacher);
      });
    });
  }

  void sortTasksBySubject() {
    setState(() {
      taskBlocks.sort((a, b) {
        return a.subject.compareTo(b.subject);
      });
    });
  }


  void sortTasksBy(int index) {
    // Implement sorting logic based on index here
    // You can call different sorting methods based on the selected index
    switch (index) {
      case 0:
        sortTasksByDeadline();
        break;
      case 1:
        sortTasksByTeacher();
        break;
      case 2:
        sortTasksBySubject();
        break;
      default:
        break;
    }
  }
}
