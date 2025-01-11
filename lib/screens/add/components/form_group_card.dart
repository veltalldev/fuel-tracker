import 'package:flutter/material.dart';

class FormGroupCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const FormGroupCard({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold, // Make title more visible
            ),
          ),
          const SizedBox(height: 16),
          ...children
              .expand((child) => [
                    child,
                    const SizedBox(height: 16),
                  ])
              .toList()
            ..removeLast(),
        ],
      ),
    );
  }
}
