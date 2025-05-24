import 'package:flutter/material.dart';
import 'package:cable_road_project/repositories/poles_list_repo.dart/models/repairs_model.dart'
    as model;
import 'package:intl/intl.dart';

class AddRepairDialog extends StatefulWidget {
  const AddRepairDialog({super.key});

  @override
  State<AddRepairDialog> createState() => _AddRepairDialogState();
}

class _AddRepairDialogState extends State<AddRepairDialog> {
  final TextEditingController _controller = TextEditingController();
  bool _isUrgent = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isSmallHeight = mediaQuery.size.height < 500;

    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: isSmallHeight ? mediaQuery.size.height * 0.8 : 400,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Добавить ремонт',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        controller: _controller,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: 'Описание ремонта',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Checkbox(
                            value: _isUrgent,
                            onChanged: (value) {
                              setState(() {
                                _isUrgent = value ?? false;
                              });
                            },
                          ),
                          const Expanded(child: Text('Приоритетный ремонт')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Отмена'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (_controller.text.trim().isNotEmpty) {
                        final now = DateTime.now();
                        final formattedDate = DateFormat(
                          'dd.MM.yyyy',
                        ).format(now);
                        Navigator.pop(
                          context,
                          model.Repair(
                            id: UniqueKey().toString(),
                            completed: false,
                            date: formattedDate,
                            description: _controller.text.trim(),
                            urgent: _isUrgent,
                          ),
                        );
                      }
                    },
                    child: const Text('Добавить'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
