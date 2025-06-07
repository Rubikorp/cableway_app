import 'package:cable_road_project/features/poles_list/bloc/poles_bloc.dart';
import 'package:cable_road_project/features/repair_list/bloc/repair_list_bloc_bloc.dart';
import 'package:cable_road_project/repositories/poles_list_repo.dart/abstract_pole_repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../widgets/widget.dart';

class RepairListScreen extends StatelessWidget {
  const RepairListScreen({super.key, required this.polesBloc});
  final PolesBloc polesBloc;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: RepairListAppBar(themeData: theme),
      body: RepairListBody(themeData: theme),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            context.read<RepairListBlocBloc>().add(SubmitRepairs());
            polesBloc.add(LoadPoles());
            Navigator.of(context).pop();
            // Navigator.of(context).pop();
          },
          child: const Text("Сохранить изменения"),
        ),
      ),
    );
  }
}
