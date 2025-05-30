import 'package:cable_road_project/data/pole_images_data.dart';
import 'package:cable_road_project/features/poles_list/bloc/poles_bloc.dart';
import 'package:cable_road_project/features/poles_list/widgets/custom_box_list.dart';
import 'package:cable_road_project/features/repair_list/bloc/repair_list_bloc_bloc.dart';
import 'package:cable_road_project/features/repair_list/views/repairs_list_screen.dart';
import 'package:cable_road_project/repositories/poles_list_repo.dart/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../../repositories/poles_list_repo.dart/abstract_pole_repositories.dart';

class PoleTile extends StatelessWidget {
  const PoleTile({super.key, required this.pole, required this.bloc});

  final Pole pole;
  final PolesBloc bloc;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final repairs = pole.repairs;
    final repairsUncomplete = repairs.where(
      (repair) => !repair.completed && !repair.urgent,
    );
    final repairsPrior = repairs.where(
      (repair) => repair.urgent && !repair.completed,
    );

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
              Positioned(
                bottom: 10,
                left: 10,
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 245, 4, 4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    pole.repairs
                        .where((repir) => repir.urgent && !repir.completed)
                        .length
                        .toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.white,
                    semanticLabel: "Удалить",
                  ),
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: const Text('Подтверждение'),
                            content: const Text(
                              'Вы уверены, что хотите удалить?',
                            ),
                            actions: [
                              TextButton(
                                onPressed:
                                    () => Navigator.of(context).pop(false),
                                child: const Text('Отмена'),
                              ),
                              TextButton(
                                onPressed:
                                    () => {
                                      bloc.add(
                                        DeletePole(deletePoleId: pole.id),
                                      ),
                                      bloc.add(LoadPoles()),
                                      Navigator.of(context).pop(true),
                                    },
                                child: const Text('Удалить'),
                              ),
                            ],
                          ),
                    );

                    if (confirmed == true) {
                      GetIt.instance<Talker>().debug("удалена $pole");
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => BlocProvider(
                        create:
                            (_) => RepairListBlocBloc(
                              GetIt.I<AbstractPoleRepositories>(),
                            )..add(LoadRepairList(pole: pole)),
                        child: RepairListScreen(),
                      ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            child: Column(
              children: [
                if (repairs.isEmpty) Center(child: Text("Ремонтов нет")),
                if (repairsPrior.isNotEmpty)
                  CustomBoxList(
                    borderColor: const Color.fromARGB(255, 255, 0, 0),
                    bgColor: Color.fromARGB(40, 255, 0, 0),
                    title: 'Приоритет:',
                    repairs: repairsPrior.map((e) => e.description).toList(),
                  ),
                if (repairsPrior.isNotEmpty) SizedBox(height: 10),
                if (repairsUncomplete.isNotEmpty)
                  CustomBoxList(
                    borderColor: const Color.fromARGB(255, 0, 94, 255),
                    bgColor: Color.fromARGB(45, 0, 94, 255),
                    title: 'Не завершенные:',
                    repairs:
                        repairsUncomplete.map((e) => e.description).toList(),
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
          ),
        ],
      ),
    );
  }
}
