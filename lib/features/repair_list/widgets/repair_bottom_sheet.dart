import 'package:cable_road_project/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repositories/poles_list_repo.dart/models/models.dart';
import '../bloc/repair_list_bloc_bloc.dart';

void showRepairBottomSheet({
  required BuildContext outerContext,
  Repair? existingRepair,
}) {
  final isEdit = existingRepair != null;
  final controller = TextEditingController(
    text: existingRepair?.description ?? '',
  );
  bool isUrgent = existingRepair?.urgent ?? false;

  showModalBottomSheet(
    context: outerContext,
    isScrollControlled: true,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller,
                    maxLines: 4,
                    decoration: const InputDecoration(labelText: "Описание"),
                    autofocus: true,
                  ),
                  CheckboxListTile(
                    title: const Text("Приоритетный ремонт"),
                    value: isUrgent,
                    onChanged: (value) {
                      setState(() => isUrgent = value ?? false);
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      final text = controller.text.trim();
                      if (text.isEmpty) return;

                      if (isEdit) {
                        outerContext.read<RepairListBlocBloc>().add(
                          EditRepairLocal(
                            oldRepair: existingRepair!,
                            newDescription: text,
                            newUrgent: isUrgent,
                          ),
                        );
                      } else {
                        outerContext.read<RepairListBlocBloc>().add(
                          AddRepairLocal(
                            repair: Repair(
                              id: UniqueKey().toString(),
                              description: text,
                              urgent: isUrgent,
                              completed: false,
                              date: formatDate(DateTime.now()),
                            ),
                          ),
                        );
                      }

                      Navigator.pop(context);
                    },
                    child: Text(isEdit ? "Сохранить" : "Добавить ремонт"),
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
