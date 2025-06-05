import 'package:cable_road_project/features/repair_list/bloc/repair_list_bloc_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/widget.dart';

class RepairListScreen extends StatelessWidget {
  const RepairListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const RepairListAppBar(),
      body: const RepairListBody(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            context.read<RepairListBlocBloc>().add(SubmitRepairs());
          },
          child: const Text("Сохранить изменения"),
        ),
      ),
    );
  }
}
