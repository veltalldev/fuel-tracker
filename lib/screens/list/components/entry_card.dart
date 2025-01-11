import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/fuel_entry.dart';

class EntryCard extends StatelessWidget {
  final FuelEntry entry;
  final VoidCallback? onTap;
  final Function(DismissDirection)? onDismissed;

  const EntryCard({
    super.key,
    required this.entry,
    this.onTap,
    this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat.yMMMd();
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    final numberFormat = NumberFormat.decimalPattern();
    final mpgFormat = NumberFormat.decimalPattern()..maximumFractionDigits = 1;

    return Dismissible(
      key: Key('entry-${entry.id}'),
      direction: DismissDirection.endToStart,
      onDismissed: onDismissed,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16.0),
        color: theme.colorScheme.error,
        child: Icon(
          Icons.delete_outline,
          color: theme.colorScheme.onError,
        ),
      ),
      child: Card(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      dateFormat.format(entry.date),
                      style: theme.textTheme.titleMedium,
                    ),
                    Text(
                      currencyFormat.format(entry.totalCost),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow(
                            context,
                            'Odometer',
                            '${numberFormat.format(entry.odometerReading)} mi',
                          ),
                          const SizedBox(height: 4.0),
                          _buildDetailRow(
                            context,
                            'Volume',
                            '${numberFormat.format(entry.fuelVolume)} gal',
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow(
                            context,
                            'Price',
                            currencyFormat.format(entry.pricePerUnit),
                          ),
                          if (entry.milesPerGallon != null) ...[
                            const SizedBox(height: 4.0),
                            _buildDetailRow(
                              context,
                              'MPG',
                              mpgFormat.format(entry.milesPerGallon),
                              textColor: theme.colorScheme.primary,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                if (entry.location != null && entry.location!.isNotEmpty) ...[
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4.0),
                      Expanded(
                        child: Text(
                          entry.location!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    Color? textColor,
  }) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label: ',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: textColor,
          ),
        ),
      ],
    );
  }
}
