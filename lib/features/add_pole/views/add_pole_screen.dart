import 'package:cable_road_project/features/add_pole/bloc/add_pole_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../repositories/poles_list_repo.dart/pole_list_repo.dart';
import 'add_pole_view.dart';

class AddPoleScreen extends StatelessWidget {
  final VoidCallback onPoleAdded;

  const AddPoleScreen({super.key, required this.onPoleAdded});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddPoleBloc(GetIt.I<AbstractPoleRepositories>()),
      child: AddPoleView(onPoleAdded: onPoleAdded),
    );
  }
}
