import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/repair_list_bloc_bloc.dart';
import 'repair_list_item.dart';

class RepairListBody extends StatelessWidget {
  const RepairListBody({super.key});

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
            return const Center(child: Text("Нет ремонтов для отображения"));
          }

          return ListView.builder(
            itemCount: filteredRepairs.length,
            itemBuilder: (context, index) {
              final repair = filteredRepairs[index];
              return RepairListItem(repair: repair);
            },
          );
        } else if (state is RepairListLoadingFailure) {
          return Center(child: Text("Ошибка: ${state.exception}"));
        } else {
          return const Center(child: Text("Нет данных"));
        }
      },
    );
  }
}
