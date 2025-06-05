import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/repair_list_bloc_bloc.dart';
import 'repair_bottom_sheet.dart';

class RepairListAppBar extends StatelessWidget implements PreferredSizeWidget {
  const RepairListAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: BlocBuilder<RepairListBlocBloc, RepairListBlocState>(
        builder: (context, state) {
          if (state is RepairListLoaded) {
            final pole = state.poleList.first;
            return Center(child: Text(pole.number));
          }
          return const Text('');
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          tooltip: 'Добавить ремонт',
          onPressed: () => showRepairBottomSheet(outerContext: context),
        ),
        BlocBuilder<RepairListBlocBloc, RepairListBlocState>(
          builder: (context, state) {
            if (state is RepairListLoaded) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder:
                    (child, animation) =>
                        ScaleTransition(scale: animation, child: child),
                child: IconButton(
                  key: ValueKey<bool>(state.showCompleted),
                  icon: Icon(
                    state.showCompleted
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
