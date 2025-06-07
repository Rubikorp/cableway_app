part of '../pole_tile.dart';

class _PoleStatusIndicators extends StatelessWidget {
  const _PoleStatusIndicators({required this.pole});

  final Pole pole;

  @override
  Widget build(BuildContext context) {
    final priorCount =
        pole.repairs.where((r) => r.urgent && !r.completed).length;
    final doneCount = pole.repairs.where((r) => r.completed).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Indicator(
          label: "Приоритет:",
          count: priorCount,
          color: Colors.redAccent.withOpacity(0.7),
          icon: Icons.priority_high,
        ),
        const SizedBox(height: 8),
        _Indicator(
          label: "Выполнено:",
          count: doneCount,
          color: Colors.greenAccent.withOpacity(0.7),
          icon: Icons.check_circle_outline,
        ),
      ],
    );
  }
}

class _Indicator extends StatelessWidget {
  const _Indicator({
    required this.label,
    required this.count,
    required this.color,
    required this.icon,
  });

  final String label;
  final int count;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '$count',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
