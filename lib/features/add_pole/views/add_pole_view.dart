import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repositories/poles_list_repo.dart/models/models.dart';
import '../bloc/add_pole_bloc.dart';
import '../widgets/widgets.dart';

class AddPoleView extends StatefulWidget {
  final VoidCallback onPoleAdded;

  const AddPoleView({super.key, required this.onPoleAdded});

  @override
  State<AddPoleView> createState() => _AddPoleViewState();
}

class _AddPoleViewState extends State<AddPoleView> {
  final _formKey = GlobalKey<FormState>();
  final numberController = TextEditingController();

  void _addPole() async {
    if (_formKey.currentState!.validate()) {
      final completer = Completer<void>();
      context.read<AddPoleBloc>().add(
        LoadAddPole(number: numberController.text, completer: completer),
      );
      await completer.future;

      if (!mounted) return;

      widget.onPoleAdded(); // вот здесь вызываем
      Navigator.of(context).pop();
    }
  }

  void _showAddRepairDialog() async {
    final result = await showDialog<Repair>(
      context: context,
      builder: (_) => const AddRepairDialog(),
    );

    if (!mounted) return;

    if (result != null) {
      context.read<AddPoleBloc>().add(AddRepairPressed(result));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Добавить опору'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: numberController,
                validator:
                    (value) => value!.isEmpty ? 'Введите название' : null,
                decoration: const InputDecoration(labelText: "Название"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _showAddRepairDialog(),
                child: const Text('Добавить ремонт'),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: BlocBuilder<AddPoleBloc, AddPoleBlocState>(
                  builder: (context, state) {
                    if (state is AddPoleLoaded) {
                      if (state.repairs.isEmpty) {
                        return const Center(child: Text('Нет ремонтов'));
                      }
                      return ListView.separated(
                        itemCount: state.repairs.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (_, index) {
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
                      );
                    }
                    return Center(child: Text('Загрузка...'));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: BlocBuilder<AddPoleBloc, AddPoleBlocState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: state is AddPoleLoading ? null : _addPole,
                child:
                    state is AddPoleLoading
                        ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                        : const Text("Добавить"),
              ),
            );
          },
        ),
      ),
    );
  }
}
