import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repositories/poles_list_repo.dart/models/models.dart';
import '../bloc/repair_list_bloc_bloc.dart';
import 'repair_bottom_sheet.dart';

class RepairListItem extends StatelessWidget {
  final Repair repair;
  final ThemeData themeData;

  const RepairListItem({
    super.key,
    required this.repair,
    required this.themeData,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(repair),
      background: Container(
        decoration: BoxDecoration(
          color: repair.completed ? Colors.blue : Colors.green,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: Icon(
          repair.completed ? Icons.exit_to_app : Icons.check,
          color: Colors.white,
        ),
      ),
      secondaryBackground: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          context.read<RepairListBlocBloc>().add(DeleteRepairLocal(repair));
          return true;
        } else if (direction == DismissDirection.startToEnd) {
          context.read<RepairListBlocBloc>().add(
            ToggleRepairCompletedLocal(repair),
          );
          return false;
        }
        return false;
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          leading: CircleAvatar(
            backgroundColor:
                repair.completed ? Colors.green : Colors.yellow.shade700,
            child: Icon(
              repair.completed ? Icons.check : Icons.build,
              color: Colors.white,
            ),
          ),
          title: Text(
            repair.description,
            style: themeData.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: repair.urgent ? Colors.redAccent : Colors.black87,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (repair.urgent)
                const Text(
                  "Приоритет",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              const SizedBox(height: 4),
              Text(
                repair.completed
                    ? "Завершено: ${repair.dateComplete ?? ''}"
                    : "Запланировано: ${repair.date}",
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              ),
            ],
          ),
          trailing: CircleAvatar(child: Icon(Icons.edit, color: Colors.white)),
          onTap: () {
            showRepairBottomSheet(
              outerContext: context,
              existingRepair: repair,
            );
          },
        ),
      ),
    );
  }
}
