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

    return Card(
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
                    style: theme.textTheme.bodyLarge?.copyWith(
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _buildMetric(
                      context,
                      Icons.speed_outlined,
                      numberFormat.format(entry.odometerReading),
                      'mi',
                    ),
                  ),
                  Expanded(
                    child: _buildMetric(
                      context,
                      Icons.local_gas_station_outlined,
                      volumeFormat.format(entry.fuelVolume),
                      'gal',
                      alignment: MainAxisAlignment.end,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetric(
    BuildContext context,
    IconData icon,
    String value,
    String unit, {
    MainAxisAlignment alignment = MainAxisAlignment.start,
  }) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: alignment,
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.onSurface.withAlpha(200),
        ),
        const SizedBox(width: 8),
        Flexible(
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
                    color: theme.colorScheme.onSurface.withAlpha(200),
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
