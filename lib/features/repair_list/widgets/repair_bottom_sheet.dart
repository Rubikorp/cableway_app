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
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Colors.white,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          left: 20,
          right: 20,
          top: 24,
        ),
        child: StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isEdit ? "Редактировать ремонт" : "Новый ремонт",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: controller,
                    maxLines: 3,
                    style: const TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      labelText: "Описание",
                      filled: true,
                      fillColor: Colors.yellow.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.yellow.shade700,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    autofocus: true,
                  ),
                  const SizedBox(height: 16),
                  CheckboxListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                    tileColor: isUrgent ? Colors.red.shade50 : null,
                    activeColor: Colors.redAccent,
                    title: const Text(
                      "Приоритетный ремонт",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    value: isUrgent,
                    onChanged: (value) {
                      setState(() => isUrgent = value ?? false);
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      final text = controller.text.trim();
                      if (text.isEmpty) return;

                      if (isEdit) {
                        outerContext.read<RepairListBlocBloc>().add(
                          EditRepairLocal(
                            oldRepair: existingRepair,
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
                    icon: Icon(isEdit ? Icons.save : Icons.add),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow.shade700,
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    label: Text(isEdit ? "Сохранить" : "Добавить ремонт"),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
