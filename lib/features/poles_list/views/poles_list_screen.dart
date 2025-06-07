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
  late final PolesBloc _polesListBloc;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _polesListBloc = PolesBloc(GetIt.I<AbstractPoleRepositories>());
    _polesListBloc.add(LoadPoles());
  }

  @override
  void dispose() {
    _polesListBloc.close(); // не забудь закрыть блок
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refreshPoles() async {
    final completer = Completer<void>();
    _polesListBloc.add(LoadPoles(completer: completer));
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Главная'),
        leading: const DrawerButton(),
        actions: [
          BlocBuilder<PolesBloc, PolesState>(
            bloc: _polesListBloc,
            builder: (context, state) {
              final isSorted = state is PolesListLoaded && state.isSorted;

              return IconButton(
                onPressed: () => _polesListBloc.add(SortPoles()),
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (child, animation) =>
                          RotationTransition(turns: animation, child: child),
                  child: Icon(
                    isSorted ? Icons.filter_alt : Icons.sort,
                    key: ValueKey(isSorted),
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
            icon: const Icon(Icons.search, color: Colors.black),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (_) => AddPoleScreen(
                    onPoleAdded: () => _polesListBloc.add(LoadPoles()),
                  ),
            ),
          );

          if (result == true) {
            _polesListBloc.add(LoadPoles());
          }
        },
        child: const Icon(Icons.add),
      ),
      body: BlocListener<PolesBloc, PolesState>(
        bloc: _polesListBloc,
        listenWhen: (prev, curr) => curr is DeletedPoleLoaded,
        listener: (context, state) {
          if (state is DeletedPoleLoaded) {
            _polesListBloc.add(LoadPoles());
          }
        },
        child: RefreshIndicator(
          onRefresh: _refreshPoles,
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
                    padding: const EdgeInsets.all(5),
                    itemCount: state.poles.length,
                    separatorBuilder:
                        (_, __) => const Divider(color: Color(0xFFFFC107)),
                    itemBuilder: (context, index) {
                      final pole = state.poles[index];
                      return PoleTile(pole: pole, bloc: _polesListBloc);
                    },
                  ),
                );
              } else if (state is PolesLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is PolesLoadingFailure) {
                return Center(
                  child: ErrorGetPolesList(
                    theme: theme,
                    polesListBloc: _polesListBloc,
                    state: state,
                  ),
                );
              } else {
                return const Center(child: Text('Нет данных'));
              }
            },
          ),
        ),
      ),
    );
  }
}
