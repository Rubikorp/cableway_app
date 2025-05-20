import 'package:flutter/material.dart';

import '../bloc/poles_bloc.dart';

class ErrorGetPolesList extends StatelessWidget {
  const ErrorGetPolesList({
    super.key,
    required this.theme,
    required PolesBloc polesListBloc,
    required this.state,
  }) : _polesListBloc = polesListBloc;

  final ThemeData theme;
  final PolesBloc _polesListBloc;
  final PolesLoadingFailure state;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: 1, color: Colors.red),
            color: const Color.fromARGB(255, 255, 180, 175),
          ),
          child: Text(
            'Ошибка: ${state.exception}',
            style: theme.textTheme.labelMedium,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            _polesListBloc.add(LoadPoles());
          },
          child: Text("Перезагрузить"),
        ),
      ],
    );
  }
}
