import 'package:flutter/material.dart';

class CollapsibleStatsSection extends StatefulWidget {
  final Widget child;

  const CollapsibleStatsSection({
    super.key,
    required this.child,
  });

  @override
  State<CollapsibleStatsSection> createState() =>
      _CollapsibleStatsSectionState();
}

class _CollapsibleStatsSectionState extends State<CollapsibleStatsSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  'Statistics',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.analytics,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
                const Spacer(),
                AnimatedRotation(
                  duration: const Duration(milliseconds: 200),
                  turns: _isExpanded ? 0.5 : 0,
                  child: Icon(
                    Icons.expand_circle_down,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
        ClipRect(
          child: AnimatedSize(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: _isExpanded ? null : 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: widget.child,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
