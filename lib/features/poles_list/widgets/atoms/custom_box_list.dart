import 'package:flutter/material.dart';

class CustomBoxList extends StatelessWidget {
  final Color borderColor;
  final Color bgColor;
  final String title;
  final List<InlineSpan> repairs;

  const CustomBoxList({
    super.key,
    required this.borderColor,
    required this.bgColor,
    required this.title,
    required this.repairs,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor, width: 1.5),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: borderColor.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: borderColor,
            ),
          ),
          const SizedBox(height: 8),
          ...repairs.map(
            (span) => Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: RichText(
                text: TextSpan(
                  style: theme.textTheme.labelMedium,
                  children: [const TextSpan(text: "• "), span],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
