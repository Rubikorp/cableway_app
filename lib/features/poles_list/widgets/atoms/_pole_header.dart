part of '../pole_tile.dart';

class _PoleHeader extends StatelessWidget {
  const _PoleHeader({required this.pole});

  final Pole pole;

  @override
  Widget build(BuildContext context) {
    final hasUrgent = pole.repairs.any((r) => r.urgent && !r.completed);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: hasUrgent ? Colors.red.shade50 : Colors.grey.shade100,
        border: Border.all(
          color: hasUrgent ? Colors.red : Colors.black26,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            pole.number,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          if (hasUrgent)
            const Padding(
              padding: EdgeInsets.only(left: 6),
              child: Icon(Icons.priority_high, color: Colors.red, size: 20),
            ),
        ],
      ),
    );
  }
}
