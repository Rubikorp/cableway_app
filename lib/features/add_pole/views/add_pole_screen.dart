import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../repositories/poles_list_repo.dart/models/models.dart';
import '../../../repositories/poles_list_repo.dart/pole_list_repo.dart';
import '../bloc/add_pole_bloc_bloc.dart';
import '../widgets/widgets.dart';

class AddPoleScreen extends StatelessWidget {
  const AddPoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddPoleBloc(GetIt.I<AbstractPoleRepositories>()),
      child: const _AddPoleView(),
    );
  }
}

class _AddPoleView extends StatelessWidget {
  const _AddPoleView();

  void _showAddRepairDialog(BuildContext context) async {
    final result = await showDialog<Repair>(
      context: context,
      builder: (_) => const AddRepairDialog(),
    );

    if (result != null) {
      context.read<AddPoleBloc>().add(AddRepairPressed(result));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<AddPoleBloc>();
    final state = bloc.state;

    return Scaffold(
      appBar: AppBar(title: const Text('Добавить опору'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              onChanged:
                  (value) => context.read<AddPoleBloc>().add(
                    AddPoleNameChanged(value),
                  ),
              decoration: const InputDecoration(labelText: "Название"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _showAddRepairDialog(context),
              child: const Text('Добавить ремонт'),
            ),
            const SizedBox(height: 10),
            if (state.repairs.isNotEmpty) const Text('Список ремонтов:'),
            if (state.repairs.isNotEmpty)
              Expanded(
                // Делаем список прокручиваемым
                child: ListView.builder(
                  itemCount: state.repairs.length,
                  itemBuilder: (context, index) {
                    final r = state.repairs[index];
                    return ListTile(
                      title: Text(r.description),
                      trailing:
                          r.urgent
                              ? const Icon(
                                Icons.priority_high,
                                color: Colors.red,
                              )
                              : null,
                    );
                  },
                ),
              ),
            if (state.error != null)
              Text(state.error!, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton(
            onPressed:
                state.isLoading
                    ? null
                    : () => {
                      context.read<AddPoleBloc>().add(
                        const SubmitPolePressed(),
                      ),
                      Navigator.of(context).pushNamed("/poles"),
                    },
            child:
                state.isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                      "Добавить",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
          ),
        ),
      ),
    );
  }
}
