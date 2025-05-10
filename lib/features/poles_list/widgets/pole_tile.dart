import 'package:flutter/material.dart';
import '../../../repositories/models/pole_model.dart';

class PoleTile extends StatelessWidget {
  const PoleTile({super.key, required this.pole});

  final Pole pole;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final repairs = pole.repairs;
    final repairsUncomplete = repairs.where(
      (repair) => !repair.completed && !repair.urgent,
    );
    final repairsPrior = repairs.where((repair) => repair.urgent);

    return ListTile(
      title: Text(pole.number, style: theme.textTheme.bodyLarge),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (repairsPrior.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text('Приоритет:', style: theme.textTheme.labelMedium),
            ),
          ...repairsPrior.map(
            (e) => Text(
              "- ${e.description}",
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
          if (repairsUncomplete.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Не завершенные:',
                style: theme.textTheme.labelMedium,
              ),
            ),
          ...repairsUncomplete.map(
            (e) => Text(
              "- ${e.description}",
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
          SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (pole.lastCheckDate != null) Text("Проверил:"),
              Row(
                children: [
                  if (pole.lastCheckDate != null) Text(pole.lastCheckDate!),
                  SizedBox(width: 20),
                  if (pole.userName != null) Text(pole.userName!),
                ],
              ),
            ],
          ),
        ],
      ),
      onTap: () => Navigator.of(context).pushNamed('/repairs'),
    );
  }
}
