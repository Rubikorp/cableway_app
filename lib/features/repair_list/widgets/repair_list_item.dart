import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repositories/poles_list_repo.dart/models/models.dart';
import '../bloc/repair_list_bloc_bloc.dart';
import 'repair_bottom_sheet.dart';

class RepairListItem extends StatelessWidget {
  final Repair repair;
  const RepairListItem({super.key, required this.repair});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(repair),
      background: Container(
        color: Colors.blue,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          context.read<RepairListBlocBloc>().add(DeleteRepairLocal(repair));
          return true;
        } else if (direction == DismissDirection.startToEnd) {
          showRepairBottomSheet(outerContext: context, existingRepair: repair);
          return false;
        }
        return false;
      },
      child: ListTile(
        title: Text(repair.description),
        subtitle:
            repair.urgent
                ? const Text(
                  "Приоритет",
                  style: TextStyle(color: Colors.redAccent, fontSize: 16),
                )
                : null,
        trailing: Icon(
          repair.completed ? Icons.check_box : Icons.check_box_outline_blank,
        ),
        onTap: () {
          context.read<RepairListBlocBloc>().add(
            ToggleRepairCompletedLocal(repair),
          );
        },
      ),
    );
  }
}
