import 'package:flutter/material.dart';

class CustomBoxList extends StatelessWidget {
  final Color borderColor;
  final Color bgColor;
  final String title;
  final List<String> repairs;

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
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: borderColor),
        color: bgColor,
      ),
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(title, style: theme.textTheme.titleMedium),
          ),
          ...repairs.map(
            (e) => Text("- $e", style: theme.textTheme.labelMedium),
          ),
        ],
      ),
    );
  }
}
