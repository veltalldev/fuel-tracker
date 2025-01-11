import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthHeader extends StatelessWidget {
  final DateTime date;

  const MonthHeader({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
      child: Row(
        children: [
          Text(
            DateFormat.yMMMM().format(date),
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Divider(
              color: theme.colorScheme.onSurface.withAlpha(30),
              thickness: theme.dividerTheme.thickness,
            ),
          ),
        ],
      ),
    );
  }
}
