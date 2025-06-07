import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/repair_list_bloc_bloc.dart';
import 'repair_bottom_sheet.dart';

class RepairListAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ThemeData themeData;

  const RepairListAppBar({super.key, required this.themeData});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: BlocBuilder<RepairListBlocBloc, RepairListBlocState>(
        builder: (context, state) {
          if (state is RepairListLoaded) {
            final pole = state.poleList.first;
            return Text(
              "Опора №${pole.number}",
              style: themeData.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            );
          }
          return const Text('');
        },
      ),
      actions: [
        Tooltip(
          message: 'Добавить ремонт',
          child: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => showRepairBottomSheet(outerContext: context),
          ),
        ),
        BlocBuilder<RepairListBlocBloc, RepairListBlocState>(
          builder: (context, state) {
            if (state is RepairListLoaded) {
              return Tooltip(
                message:
                    state.showCompleted
                        ? 'Показать невыполненные'
                        : 'Показать выполненные',
                child: AnimatedSwitcher(
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
                      color:
                          state.showCompleted
                              ? Colors.green
                              : Colors.grey.shade800,
                    ),
                    onPressed: () {
                      context.read<RepairListBlocBloc>().add(
                        ToggleRepairCompletionViewEvent(),
                      );
                    },
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
