import 'package:cable_road_project/features/poles_list/bloc/poles_bloc.dart';
import 'package:cable_road_project/features/poles_list/widgets/pole_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PoleSearchDelegate extends SearchDelegate<String> {
  final PolesBloc polesBloc;

  PoleSearchDelegate({required this.polesBloc});

  @override
  TextStyle? get searchFieldStyle =>
      TextStyle(color: Colors.black, fontSize: 18);

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: theme.appBarTheme, // ← цвет всей строки
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: Color.fromARGB(179, 0, 0, 0)),
        border: InputBorder.none,
      ),
    );
  }

  @override
  String get searchFieldLabel => 'Поиск...';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
            polesBloc.add(ResetPoles()); // Вернуть изначальный список
            showSuggestions(context);
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        polesBloc.add(ResetPoles()); // Вернуть исходный список
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    polesBloc.add(SearchPole(query: query)); // отправка события поиска

    return BlocBuilder<PolesBloc, PolesState>(
      bloc: polesBloc,
      builder: (context, state) {
        if (state is PolesListLoaded) {
          final poles = state.poles;

          if (poles.isEmpty) {
            return Center(child: Text('Ничего не найдено'));
          }

          return ListView.separated(
            padding: EdgeInsets.all(10),
            itemCount: poles.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder:
                (context, index) =>
                    PoleTile(pole: poles[index], bloc: polesBloc),
          );
        } else if (state is PolesLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is PolesLoadingFailure) {
          return Center(child: Text('Ошибка: ${state.exception}'));
        } else {
          return Center(child: Text('Нет данных'));
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(); //рекомендации
  }

  @override
  void close(BuildContext context, String result) {
    polesBloc.add(ResetPoles()); // сбрасываем состояние
    super.close(context, result);
  }
}
