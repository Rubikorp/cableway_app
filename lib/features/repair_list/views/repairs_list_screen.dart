import 'package:cable_road_project/features/repair_list/bloc/repair_list_bloc_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RepairListScreen extends StatelessWidget {
  const RepairListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<RepairListBlocBloc, RepairListBlocState>(
          builder: (context, state) {
            if (state is RepairListLoaded) {
              final pole = state.poleList.first;
              return Center(child: Text(pole.number));
            }
            return Text('');
          },
        ),
        actions: [
          BlocBuilder<RepairListBlocBloc, RepairListBlocState>(
            builder: (context, state) {
              if (state is RepairListLoaded) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (child, animation) =>
                          ScaleTransition(scale: animation, child: child),
                  child: IconButton(
                    // Меняем key, чтобы AnimatedSwitcher понимал, что иконка поменялась
                    key: ValueKey<bool>(state.showCompleted),
                    icon: Icon(
                      state.showCompleted
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: state.showCompleted ? Colors.green : Colors.grey,
                    ),
                    tooltip:
                        state.showCompleted
                            ? 'Показать невыполненные'
                            : 'Показать выполненные',
                    onPressed: () {
                      context.read<RepairListBlocBloc>().add(
                        ToggleRepairCompletionViewEvent(),
                      );
                    },
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<RepairListBlocBloc, RepairListBlocState>(
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
                return ListTile(
                  title: Text(repair.description),
                  subtitle: Text(
                    repair.urgent ? "Приоритет" : '',
                    style: TextStyle(color: Colors.redAccent, fontSize: 16),
                  ),
                  trailing: Icon(
                    repair.completed
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                  ),
                );
              },
            );
          } else if (state is RepairListLoadingFailure) {
            return Center(child: Text("Ошибка: ${state.exception}"));
          } else {
            return const Center(child: Text("Нет данных"));
          }
        },
      ),
    );
  }
}
