import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/fuel_entry.dart';
import 'package:google_fonts/google_fonts.dart';

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
    final dateFormat = DateFormat.MMMd();
    final numberFormat = NumberFormat('#,##0');
    final volumeFormat = NumberFormat.decimalPattern()
      ..maximumFractionDigits = 2;
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    return Dismissible(
      key: Key(entry.id.toString()),
      direction: DismissDirection.endToStart,
      onDismissed: onDismissed,
      confirmDismiss: (_) async => true,
      dismissThresholds: const {
        DismissDirection.endToStart: 0.4,
      },
      movementDuration: const Duration(milliseconds: 200),
      background: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.error,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: const Icon(
          Icons.delete_rounded,
          color: Colors.white,
          size: 24,
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 20,
            ),
            child: Column(
              children: [
                // Date and Amount Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      dateFormat.format(entry.date),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withAlpha(200),
                      ),
                    ),
                    Text(
                      currencyFormat.format(entry.totalCost),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: theme.colorScheme.onSurface.withAlpha(200),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Metrics Row
                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: _buildMetric(
                        context,
                        Icons.speed_outlined,
                        numberFormat.format(entry.odometerReading),
                        'mi',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 4,
                      child: _buildMetric(
                        context,
                        Icons.local_gas_station_outlined,
                        volumeFormat.format(entry.fuelVolume),
                        'gal',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 4,
                      child: _buildMetric(
                        context,
                        Icons.attach_money,
                        currencyFormat.format(entry.pricePerUnit),
                        '/gal',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetric(
    BuildContext context,
    IconData icon,
    String value,
    String unit,
  ) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.onSurface.withOpacity(0.7),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
                    height: 1.2,
                  ),
                ),
                TextSpan(
                  text: ' $unit',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
