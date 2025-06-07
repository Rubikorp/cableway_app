import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/repair_list_bloc_bloc.dart';
import 'repair_list_item.dart';

class RepairListBody extends StatelessWidget {
  final ThemeData themeData;
  const RepairListBody({super.key, required this.themeData});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RepairListBlocBloc, RepairListBlocState>(
      builder: (context, state) {
        if (state is RepairListLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is RepairListLoaded) {
          final pole = state.poleList.first;
          final filteredRepairs =
              pole.repairs
                  .where((r) => r.completed == state.showCompleted)
                  .toList();

          if (filteredRepairs.isEmpty) {
            return const Center(
              child: Text(
                "Нет ремонтов для отображения",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: filteredRepairs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final repair = filteredRepairs[index];
              return RepairListItem(repair: repair, themeData: themeData);
            },
          );
        } else if (state is RepairListLoadingFailure) {
          return Center(
            child: Text(
              "Ошибка: ${state.exception}",
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else {
          return const Center(child: Text("Нет данных"));
        }
      },
    );
  }
}
