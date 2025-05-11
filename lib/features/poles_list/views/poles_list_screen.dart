import 'dart:async';

import 'package:cable_road_project/features/poles_list/bloc/poles_bloc.dart';
import 'package:cable_road_project/features/poles_list/widgets/pole_tile.dart';
import 'package:cable_road_project/repositories/abstract_pole_repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class PolesListScreen extends StatefulWidget {
  const PolesListScreen({super.key});

  @override
  State<PolesListScreen> createState() => _PolesListScreenState();
}

class _PolesListScreenState extends State<PolesListScreen> {
  final _polesListBloc = PolesBloc(GetIt.I<AbstractPoleRepositories>());

  @override
  void initState() {
    _polesListBloc.add(LoadPoles());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Главная'),
        actions: [
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: () {
              _polesListBloc.add(SortPoles());
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final completer = Completer<void>();
          _polesListBloc.add(LoadPoles(completer: completer));
          return completer.future;
        },
        child: BlocBuilder<PolesBloc, PolesState>(
          bloc: _polesListBloc,
          builder: (context, state) {
            if (state is PolesListLoaded) {
              return ListView.separated(
                padding: EdgeInsets.all(10),
                itemCount: state.poles.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final pole = state.poles[index];
                  return PoleTile(pole: pole);
                },
              );
            } else if (state is PolesLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is PolesLoadingFailure) {
              return Center(child: Text('Ошибка: ${state.exception}'));
            } else {
              return Center(child: Text('Нет данных'));
            }
          },
        ),
      ),
    );
  }
}
