import 'package:cable_road_project/data/pole_images_data.dart';
import 'package:cable_road_project/features/poles_list/widgets/custom_box_list.dart';
import 'package:cable_road_project/repositories/models/models.dart';
import 'package:flutter/material.dart';
import '../../../repositories/models/pole_model.dart';

class PoleTile extends StatelessWidget {
  const PoleTile({super.key, required this.pole});

  final Pole pole;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final repairs = pole.repairs;
    final repairsUncomplete = repairs.where(
      (repair) => !repair.completed && !repair.urgent,
    );
    final repairsPrior = repairs.where((repair) => repair.urgent);

    return ListTile(
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(20),
                child: Center(
                  child: Image.asset(
                    imgPoleSrc
                        .firstWhere(
                          (e) => e.number == pole.number,
                          orElse:
                              () => PoleImage(
                                number: 'unknown',
                                assetPath: 'assets/poles/pole.png',
                              ),
                        )
                        .assetPath,
                    height: 250,
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(pole.number, style: theme.textTheme.titleLarge),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          if (repairsPrior.isNotEmpty)
            CustomBoxList(
              borderColor: const Color.fromARGB(255, 255, 0, 0),
              bgColor: Color.fromARGB(78, 255, 0, 0),
              title: 'Приоритет:',
              repairs: repairsUncomplete.map((e) => e.description).toList(),
            ),
          if (repairsPrior.isNotEmpty) SizedBox(height: 10),
          if (repairsUncomplete.isNotEmpty)
            CustomBoxList(
              borderColor: const Color.fromARGB(255, 0, 94, 255),
              bgColor: Color.fromARGB(78, 0, 94, 255),
              title: 'Не завершенные:',
              repairs: repairsUncomplete.map((e) => e.description).toList(),
            ),
          if (repairsUncomplete.isNotEmpty) SizedBox(height: 10),
          if (pole.lastCheckDate != null)
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 1),
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(54, 76, 175, 79),
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (pole.lastCheckDate != null)
                    Text("Проверил:", style: theme.textTheme.labelMedium),
                  Row(
                    children: [
                      if (pole.lastCheckDate != null)
                        Text(
                          pole.lastCheckDate!,
                          style: theme.textTheme.labelMedium,
                        ),
                      SizedBox(width: 10),
                      if (pole.userName != null)
                        Text(
                          pole.userName!,
                          style: theme.textTheme.labelMedium,
                        ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
      onTap: () => Navigator.of(context).pushNamed('/repairs'),
    );
  }
}
