import 'package:cable_road_project/data/pole_images_data.dart';
import 'package:cable_road_project/features/poles_list/bloc/poles_bloc.dart';
import 'package:cable_road_project/features/repair_list/bloc/repair_list_bloc_bloc.dart';
import 'package:cable_road_project/features/repair_list/views/repairs_list_screen.dart';
import 'package:cable_road_project/repositories/poles_list_repo.dart/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../../repositories/poles_list_repo.dart/abstract_pole_repositories.dart';
import 'atoms/atoms.dart';

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
    void deletePole() {
      bloc.add(DeletePole(deletePoleId: pole.id));
      if (bloc.state is DeletedPoleLoaded) {
        bloc.add(LoadPoles());
        Navigator.of(context).pop(true);
      }
    }

    return ListTile(
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black45),
                  gradient: RadialGradient(
                    colors: [
                      const Color.fromARGB(255, 255, 255, 255),
                      const Color.fromARGB(255, 248, 248, 248),
                    ],
                  ),
                ),
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(border: Border.all()),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      pole.number,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (pole.repairs
                                        .where(
                                          (rep) =>
                                              rep.urgent == true &&
                                              rep.completed == false,
                                        )
                                        .isNotEmpty)
                                      Text(
                                        " !",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Приоритет: ",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                        108,
                                        255,
                                        17,
                                        0,
                                      ),
                                    ),
                                    child: Text(
                                      pole.repairs
                                          .where(
                                            (repir) =>
                                                repir.urgent &&
                                                !repir.completed,
                                          )
                                          .length
                                          .toString(),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Выполнено: ",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                        108,
                                        51,
                                        255,
                                        0,
                                      ),
                                    ),
                                    child: Text(
                                      pole.repairs
                                          .where((repir) => repir.completed)
                                          .length
                                          .toString(),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(border: Border.all()),
                                child:
                                    (pole.lastCheckDate != null &&
                                            pole.userName != null)
                                        ? Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "Проверил: ",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Text(
                                                  pole.userName!,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 2),
                                            Row(
                                              children: [
                                                Text(
                                                  "Дата: ",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Text(
                                                  pole.lastCheckDate!,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                        : Text(
                                          "Не проверено",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                        SizedBox(width: 20),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, right: 10),
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
                            height: MediaQuery.of(context).size.height * 0.2,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
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
                      child: Column(
                        children: [
                          Center(
                            child: Text(
                              "Список ремонтов:",
                              style: theme.textTheme.titleMedium,
                            ),
                          ),
                          SizedBox(height: 10),
                          if (repairs
                              .where((repair) => repair.completed == false)
                              .isEmpty)
                            Text(
                              "Ремонтов нет",
                              style: theme.textTheme.labelMedium,
                            ),

                          if (repairsPrior.isNotEmpty) ...[
                            CustomBoxList(
                              borderColor: const Color.fromARGB(255, 255, 0, 0),
                              bgColor: const Color.fromARGB(40, 255, 0, 0),
                              title: 'Приоритет:',
                              repairs:
                                  repairsPrior
                                      .map((e) => e.description)
                                      .toList(),
                            ),
                            const SizedBox(height: 10),
                          ],

                          if (repairsUncomplete.isNotEmpty) ...[
                            CustomBoxList(
                              borderColor: const Color.fromARGB(
                                255,
                                0,
                                94,
                                255,
                              ),
                              bgColor: const Color.fromARGB(45, 0, 94, 255),
                              title: 'Не завершенные:',
                              repairs:
                                  repairsUncomplete
                                      .map((e) => e.description)
                                      .toList(),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Color.fromARGB(255, 255, 17, 0),
                  ),
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            content: Text(
                              'Вы уверены, что хотите удалить? \n"${pole.number}"',
                              textAlign: TextAlign.center,
                            ),
                            actions: [
                              TextButton(
                                onPressed:
                                    () => Navigator.of(context).pop(false),
                                child: const Text('Отмена'),
                              ),
                              TextButton(
                                onPressed: deletePole,
                                child: const Text(
                                  'Удалить',
                                  style: TextStyle(color: Colors.red),
                                ),
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
        ],
      ),
    );
  }
}
