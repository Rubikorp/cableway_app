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
    final theme = Theme.of(context);
    final yellow = Colors.yellow.shade700;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить опору'),
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: theme.textTheme.titleLarge?.copyWith(
          color: Colors.black,
        ),
      ),
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
                decoration: InputDecoration(
                  labelText: "Название",
                  labelStyle: const TextStyle(color: Colors.black54),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: yellow),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: yellow, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _showAddRepairDialog,
                  icon: const Icon(Icons.build),
                  label: const Text('Добавить ремонт'),
                ),
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            tileColor: Colors.yellow.shade50,
                            title: Text(
                              r.description,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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
                    return const Center(child: CircularProgressIndicator());
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
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: state is AddPoleLoading ? null : _addPole,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: yellow,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:
                      state is AddPoleLoading
                          ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          )
                          : const Text("Добавить"),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
