part of '../pole_tile.dart';

class _PoleCheckInfo extends StatelessWidget {
  const _PoleCheckInfo({required this.pole});

  final Pole pole;

  @override
  Widget build(BuildContext context) {
    final isChecked = pole.lastCheckDate != null && pole.userName != null;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: isChecked ? Colors.green.shade50 : Colors.grey.shade200,
        border: Border.all(color: isChecked ? Colors.green : Colors.black26),
        borderRadius: BorderRadius.circular(10),
      ),
      child:
          isChecked
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Проверил:",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  Text(
                    pole.userName!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.date_range,
                        size: 18,
                        color: Colors.black45,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        pole.lastCheckDate!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              )
              : Row(
                children: const [
                  Icon(Icons.warning_amber_rounded, color: Colors.orange),
                  SizedBox(width: 8),
                  Text(
                    "Не проверено",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
    );
  }
}
