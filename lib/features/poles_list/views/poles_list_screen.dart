import 'dart:async';

import 'package:cable_road_project/features/poles_list/bloc/poles_bloc.dart';
import 'package:cable_road_project/features/poles_list/widgets/widget.dart';
import 'package:cable_road_project/repositories/poles_list_repo.dart/abstract_pole_repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../add_pole/add_pole.dart';

class PolesListScreen extends StatefulWidget {
  const PolesListScreen({super.key});

  @override
  State<PolesListScreen> createState() => _PolesListScreenState();
}

class _PolesListScreenState extends State<PolesListScreen> {
  final _polesListBloc = PolesBloc(GetIt.I<AbstractPoleRepositories>());
  final _scrollController = ScrollController();

  @override
  void initState() {
    _polesListBloc.add(LoadPoles());
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (_) => AddPoleScreen(
                    onPoleAdded: () {
                      _polesListBloc.add(LoadPoles());
                    },
                  ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Главная'),
        leading: DrawerButton(),
        actions: [
          BlocBuilder<PolesBloc, PolesState>(
            bloc: _polesListBloc,
            builder: (context, state) {
              final isSorted = state is PolesListLoaded && state.isSorted;

              return IconButton(
                onPressed: () {
                  _polesListBloc.add(SortPoles());
                },
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return RotationTransition(turns: animation, child: child);
                  },
                  child: Icon(
                    isSorted ? Icons.filter_alt : Icons.sort,
                    key: ValueKey<bool>(isSorted), // обязательно для анимации
                  ),
                ),
              );
            },
          ),
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: PoleSearchDelegate(polesBloc: _polesListBloc),
              );
            },
            icon: Icon(Icons.search, color: Colors.black),
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
              return Scrollbar(
                thumbVisibility: true,
                controller: _scrollController,
                interactive: true,
                child: ListView.separated(
                  controller: _scrollController,
                  padding: EdgeInsets.all(5),
                  itemCount: state.poles.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final pole = state.poles[index];
                    return PoleTile(pole: pole, bloc: _polesListBloc);
                  },
                ),
              );
            } else if (state is PolesLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is PolesLoadingFailure) {
              return Center(
                child: ErrorGetPolesList(
                  theme: theme,
                  polesListBloc: _polesListBloc,
                  state: state,
                ),
              );
            } else {
              return Center(child: Text('Нет данных'));
            }
          },
        ),
      ),
      drawer: const AppDrawer(),
    );
  }
}
