import 'dart:async';

import 'package:cable_road_project/features/poles_list/bloc/poles_bloc.dart';
import 'package:cable_road_project/repositories/poles_list_repo.dart/models/pole_model.dart';
import 'package:cable_road_project/repositories/poles_list_repo.dart/pole_list_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../../data/pole_images_data.dart';
import '../../../repositories/poles_list_repo.dart/models/models.dart';
import '../../repair_list/bloc/repair_list_bloc_bloc.dart';
import '../../repair_list/views/view.dart';
import 'atoms/custom_box_list.dart';
part 'atoms/_delete_pole_button.dart';
part 'atoms/_pole_card.dart';
part 'atoms/_pole_header.dart';
part 'atoms/_poles_check_info.dart';
part 'atoms/_poles_image.dart';
part 'atoms/_poles_status_indicators.dart';
part 'atoms/_repairs_list_button.dart';

class PoleTile extends StatelessWidget {
  const PoleTile({
    super.key,
    required this.pole,
    required this.bloc,
    this.searchQuery,
  });

  final Pole pole;
  final PolesBloc bloc;
  final String? searchQuery;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(10),
      subtitle: Stack(
        children: [
          _PoleCard(pole: pole, bloc: bloc, searchQuery: searchQuery),
          _DeletePoleButton(pole: pole, bloc: bloc),
        ],
      ),
    );
  }
}
